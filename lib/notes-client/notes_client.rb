# -*- encoding : utf-8 -*-

module NotesClient

  @config = {
    url: "http://notes.ataxo.com",
    version: :v1,
    taxonomy: :sandbox,
    api_token: "NotesApi.api_token = 'YOUR TOKEN'",

    #logger
    logger_level: :info,
  }
  @find_options = {
    limit: 10,
    offset: 0
  }

  @logger = nil

  def self.logger= logger
    logger.level = Logger.const_get(@config[:logger_level].to_s.upcase)
    @logger = logger
  end

  def self.logger_level= level
    @config[:logger_level] = level
  end

  def self.logger
    @logger
  end

  def self.log request
    if @logger
      @logger.debug "#{"-"*80}\nHeader: #{request[:header]}\nRequest: #{request[:verb]}\nURL: #{request[:url]}\n#{request[:response]}\nPARAMS:#{request[:params]}"
      verb = "#{request[:verb].to_s.upcase}"

      message = "NotesClient:".cyan + " " + verb.yellow + " "*(8-verb.size)
      if request[:response_hash][:status] == "error"
        executed = "ERROR"
        message += executed.red + " "*(8-executed.size)
        message +=  "#{request[:url]}" + " "
        message +=  request[:response_hash][:message].red
      else
        executed = "#{request[:response_hash][:executed_in].gsub("s","").to_f.round(3)}s"
        message += executed.green + " "*(8-executed.size)
        message +=  "#{request[:url]}" + " "
      end

      @logger.info message
    end
  end

  def self.url= url
    @config[:url] = url
  end

  def self.url
    @config[:url]
  end

  def self.version= version
    @config[:version] = version
  end

  def self.version
    @config[:version]
  end

  def self.taxonomy= taxonomy
    @config[:taxonomy] = taxonomy
  end

  def self.taxonomy
    @config[:taxonomy]
  end

  def self.api_token= api_token
    @config[:api_token] = api_token
  end

  def self.api_token
    @config[:api_token]
  end

  def self.config
    @config
  end

  def self.config= conf
    @config.merge!(conf)
  end

  def self.api_url object_name, method = nil
    "#{@config[:url]}/#{@config[:version]}/#{@config[:taxonomy]}/#{object_name.to_s.pluralize}#{ method ? "/#{method}" : ""}"
  end

  def self.find_options= opts
    @find_options = opts
  end

  def self.find_options
    Marshal.load(Marshal.dump(@find_options))
  end
end