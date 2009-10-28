require 'open3'

Dir.chdir File.dirname(__FILE__)

watch(/(?:lib|test).*\.rb$/)  { |something|

  Dir['lib/**/*.rb'].inject(true) do |check, path|
    Open3.popen3('ruby', '-c', path) { |_, o, stderr|
      errors = stderr.read

      if errors.empty? then check
      else
        puts errors
        false
      end
    }
  end and begin
  
    messages = Dir['test/**/test_*.rb'].inject([]) do |messages, path|
      if path !~ /test_helper\.rb$/
        Open3.popen3('rake test') do |_, o, e|
          puts e.read, message = o.read

          result = message.split($/).last
          tests, assertions, failures, errors =
              result.split(', ').map! { |r| r.to_i }

          failures ||= 0
          errors ||= 0

          unless failures.zero? and errors.zero?
#            Open3.popen3(bad_message) { |i, *| i << message[0, 160] }
          else
#            system(good_message)
          end

          messages << message
        end
      end

      messages
    end


  end

}
