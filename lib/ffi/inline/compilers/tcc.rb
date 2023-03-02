#--
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module FFI; module Inline

Compiler.define :tcc do
  def exists?
    `tcc -v 2>&1'`; $?.success?
  end

  def compile (code, libraries = [])
    @code      = code
    @libraries = libraries

    return output if File.exist?(output)

    cmd = if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/
      "sh -c '#{ldshared} #{ENV['CFLAGS']} #{libs} -o #{output.shellescape} #{input.shellescape}' 2>>#{log.shellescape}"
    else
      "#{ldshared} #{ENV['CFLAGS']} #{libs} -o #{output.shellescape} #{input.shellescape} 2>>#{log.shellescape}"
    end
    File.write(log, cmd + "\n")
    unless system(cmd)
      raise CompilationError.new(log)
    end

    output
  end

private
  def digest
    Digest::SHA1.hexdigest(@code + @libraries.to_s + @options.to_s)
  end

  def input
    File.join(Inline.directory, "#{digest}.c").tap {|path|
      File.open(path, 'w') { |f| f.write(@code) } unless File.exist?(path)
    }
  end

  def output
    File.join(Inline.directory, "#{digest}.#{Compiler::Extension}")
  end

  def log
    File.join(Inline.directory, "#{digest}.log")
  end

  def ldshared
    if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/
      "tcc -rdynamic -shared -fPIC #{options} #{ENV['LDFLAGS']}"
    else
      "tcc -shared #{options} #{ENV['LDFLAGS']}"
    end
  end

  def libs
    @libraries.map { |lib| "-l#{lib}".shellescape }.join(' ')
  end

end

end; end
