module TestPilot::Helpers

  def home_directory
    running_on_windows? ? ENV['USERPROFILE'].gsub("\\","/") : ENV['HOME']
  end


  def running_on_windows?
    RUBY_PLATFORM =~ /mswin32|mingw32/
  end

  def running_on_a_mac?
    RUBY_PLATFORM =~ /-darwin\d/
  end

  def display(msg="", new_line=true)
    if new_line
      puts(msg)
    else
      print(msg)
      STDOUT.flush
    end
  end

  def redisplay(line, line_break = false)
    display("\r\e[0K#{line}", line_break)
  end

  def deprecate(version)
    display "!!! DEPRECATION WARNING: This command will be removed in version #{version}"
    display
  end

  def error(msg)
    STDERR.puts(format_with_bang(msg))
    exit 1
  end

  def confirm(message="Are you sure you wish to continue? (y/n)?")
    display("#{message} ", false)
    ask.downcase == 'y'
  end

  def format_date(date)
    date = Time.parse(date) if date.is_a?(String)
    date.strftime("%Y-%m-%d %H:%M %Z")
  end

  def ask
    STDIN.gets.strip
  end

  def exec(cmd)
    FileUtils.cd(Dir.pwd) {|d| return `#{cmd}`}
  end

  def has_git?
    %x{ git --version }
    $?.success?
  end

  def git(args)
    return "" unless has_git?
    flattened_args = [args].flatten.compact.join(" ")
    %x{ git #{flattened_args} 2>&1 }.strip
  end

  def time_ago(elapsed)
    if elapsed < 60
      "#{elapsed.floor}s ago"
    elsif elapsed < (60 * 60)
      "#{(elapsed / 60).floor}m ago"
    else
      "#{(elapsed / 60 / 60).floor}h ago"
    end
  end

  def truncate(text, length)
    if text.size > length
      text[0, length - 2] + '..'
    else
      text
    end
  end

  def action(message)
    output_with_arrow("#{message}... ", false)
    # Heroku::Helpers.enable_error_capture
    # yield
    # Heroku::Helpers.disable_error_capture
    display "done", false
    display(", #{@status}", false) if @status
    display
  end

  def status(message)
    @status = message
  end

  def output(message="", new_line=true)
    return if message.to_s.strip == ""
    display("       " + message.split("\n").join("\n       "), new_line)
  end

  def output_with_arrow(message="", new_line=true)
    return if message.to_s.strip == ""
    display("-----> " + message.split("\n").join("\n       "), new_line)
  end

  def format_with_bang(message)
    return '' if message.to_s.strip == ""
    " !    " + message.split("\n").join("\n !    ")
  end

  def output_with_bang(message="", new_line=true)
    return if message.to_s.strip == ""
    display(format_with_bang(message), new_line)
  end

  def error_with_failure(message)
    display "failed"
    output_with_bang(message)
    exit 1
  end

  def display_header(message="", new_line=true)
    return if message.to_s.strip == ""
    display("=== " + message.to_s.split("\n").join("\n=== "), new_line)
  end

  def display_object(object)
    case object
    when Array
      # list of objects
      object.each do |item|
        display_object(item)
      end
    when Hash
      # if all values are arrays, it is a list with headers
      # otherwise it is a single header with pairs of data
      if object.values.all? {|value| value.is_a?(Array)}
        object.keys.sort_by {|key| key.to_s}.each do |key|
          display_header(key)
          display_object(object[key])
          hputs
        end
      end
    else
      hputs(object.to_s)
    end
  end

  def hputs(string='')
    Kernel.puts(string)
  end

  def hprint(string='')
    Kernel.print(string)
    STDOUT.flush
  end

end
