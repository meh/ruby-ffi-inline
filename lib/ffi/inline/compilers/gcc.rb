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

Compiler.define :gcc do
  def exists?
    `gcc -v 2>&1'`; $?.success?
  end

  def compile (code, libraries = [])
    @code      = code
    @libraries = libraries

    return output if File.exists?(output)

    cmd = if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/
      "sh -c '#{ldshared} #{ENV['CFLAGS']} -o #{output.shellescape} #{input.shellescape} #{libs}' 2>>#{log.shellescape}"
    else
      "#{ldshared} #{ENV['CFLAGS']} -o #{output.shellescape} #{input.shellescape} #{libs} 2>>#{log.shellescape}"
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
      File.open(path, 'w') { |f| f.write(@code) } unless File.exists?(path)
    }
  end

  def output
    File.join(Inline.directory, "#{digest}.#{Compiler::Extension}")
  end

  def log
    File.join(Inline.directory, "#{digest}.log")
  end

  def ldshared
    if RbConfig::CONFIG['target_os'] =~ /darwin/
      "gcc -dynamic -bundle -fPIC #{options} #{ENV['LDFLAGS']}"
    else
      "gcc -shared -fPIC #{options} #{ENV['LDFLAGS']}"
    end
  end

  def libs
    @libraries.map { |lib| "-l#{lib}".shellescape }.join(' ')
  end
end

end; end
