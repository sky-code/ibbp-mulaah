GrapeSwaggerRails.options.url           = '/api/swagger_doc'
GrapeSwaggerRails.options.app_url       = ENV['ROUTES_HOST']
GrapeSwaggerRails.options.api_key_name  = 'Authorization'
GrapeSwaggerRails.options.api_key_type  = 'header'
GrapeSwaggerRails.options.doc_expansion = 'list'

module Grape
  module ContentTypes
    def self.content_types_for(from_settings)
      ActiveSupport::OrderedHash[ :json, 'application/json' ]
    end
  end
end