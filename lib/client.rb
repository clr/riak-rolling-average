class Client
  def self.id
    @@id ||= ENV['CLIENT']
    raise "You must specific a CLIENT environment variable when you invoke this script!" unless @@id

    @@id
  end
end
