# -*- encoding : utf-8 -*-

module NotesClient
  module NotesObject

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def all
        find limit: -1
      end

      def create args = {}
        request(:post, args)
      end

      def delete args = {}
        request(:delete, args)
      end

      def find args = {}
        find_args = NotesClient.find_options.merge(args)
        response = request(:get, find_args)
        if response[:status] == "ok"
          out = response["#{self::NAME.to_s.pluralize}".to_sym].collect{ |arg|
            new(arg.symbolize_keys).exists!
          }
          array = NotesArray.new out
          array.find_options = find_args
          array.total_count = response[:total_count]
          array.limit = find_args[:limit]
          array.offset = find_args[:offset]
          array.find_object = self
          array
        else
          raise "#{response[:error_type]} - #{response[:message]}"
        end
      end

      def request verb, params = {}, method = nil

        curl = Curl::Easy.new
        curl.headers["Api-Token"] = NotesClient.api_token
        curl.headers["Content-Type"] = "application/json"
        curl.verbose = false
        curl.resolve_mode = :ipv4

        #set right url dependetnly on verb
        url = NotesClient.api_url(self::NAME, method)
        case verb
        when :get then
          curl.url = url
          curl.headers["X-HTTP-Method-override"] = "get"
        when :post then
          curl.url = url
        when :put then
          curl.url = url+ (params.is_a?(Hash) && params[:id] ? "/#{params[:id]}" : "")
        when :delete then
          curl.url = url+ (params.is_a?(Hash) && params[:id] ? "/#{params[:id]}" : "")
        end

        curl.post_body = Yajl::Encoder.encode(params)

        curl.http verb.to_s.upcase
        response = Yajl::Parser.parse(curl.body_str, symbolize_keys: true)
        NotesClient.log(header: curl.headers, verb: (verb == :find ? :get : verb), url: curl.url, params: params, response: curl.body_str, response_hash: response)
        response
      end

    end

    module InstanceMethods
      def exists!
        @exists = true
        self
      end

      def exists?
        @exists
      end

      def save
        if exists?
          update
        else
          response = self.class.request(:post, self)
          if response[:status] == "ok"
            exists!
            self.id = response["#{self.class::NAME}".to_sym][:id]
            true
          elsif response[:error_type] == "ApiError::BadRequest"
            @errors = response[:message]
            false
          else
            raise "#{response[:error_type]} - #{response[:message]}"
          end
        end
      end

      def update
        response = self.class.request(:put, self)
        if response[:status] == "ok"
          self.id = response["#{self.class::NAME}".to_sym][:id]
          true
        elsif response[:error_type] == "ApiError::BadRequest"
          @errors = response[:message]
          false
        else
          raise "#{response[:error_type]} - #{response[:message]}"
        end
      end

      def update_attributes args = {}
        self.merge!{args.symbolize_keys}
        update
      end

      def errors
        @errors ||= []
      end

    end

  end
end