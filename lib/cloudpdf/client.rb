module CloudPDF

  class Client

    def initialize(config)
      @api_key = config.fetch(:api_key)
      @cloud_name = config.fetch(:cloud_name, nil)
      @signing_secret = config.fetch(:signing_secret, nil)
      @signed = false

      if !@signing_secret.nil? && !@cloud_name.nil?
        @signed = true
      end
    end

    def setSigned(enabled)
      if @signing_secret.nil? || @cloud_name.nil?
        raise "signing_secret and cloud_name should be set"
      end

      @signed = enabled
    end

    def account
      get_response("APIV2GetAccount", "/account")
    end

    def auth
      get_response("APIV2GetAuth", "/account")
    end

    def create_document(payload)
    	post_response("APIV2CreateDocument", "/documents", payload)
    end

    def get_document(id)
      get_response("APIV2GetDocument", "/documents/" + id, {id: id})
    end

    def update_document(id, payload)
      put_response("APIV2UpdateDocument", "/documents/" + id, {id: id, **payload})
    end

    def delete_document(id)
      delete_response("APIV2DeleteDocument", "/documents/" + id, {id: id})
    end

    def create_new_file_version(id, payload)
      post_response(
        "APIV2CreateDocumentFile", 
        "/documents/" + id + "/files",
        {id: id, **payload}
      )
    end

    def upload_document_file_complete(id, fileId)
      patch_response(
        "APIV2PatchDocumentFile",
        "/documents/" + id + "/files/" + fileId,
        {id: id, fileId: fileId, uploadCompleted: true}
      )
    end

    def get_document_file(documentId, fileId)
      get_response("APIV2GetDocumentFile", "/documents/" + documentId + "/files/" + fileId, {id: documentId, fileId: fileId})
    end

    def get_viewer_token(params, expires_in = 60*60)
      get_signed_token("APIGetDocument", params, expires_in)
    end

    def create_webhook(payload)
    	post_response("APIV2CreateWebhook", "/webhooks", payload)
    end

    def get_webhook(id)
      get_response("APIV2GetWebhook", "/webhooks/" + id, {id: id})
    end

    def update_webhook(id, payload)
      put_response("APIV2UpdateWebhook", "/webhooks/" + id, {id: id, **payload})
    end

    def delete_webhook(id)
      delete_response("APIV2DeleteWebhook", "/webhooks/" + id, {id: id})
    end

    def get_webhooks()
      get_response("APIV2GetWebhooks", "/webhooks")
    end

    private

    CLOUDPDF_API_ENDPOINT = "https://api.cloudpdf.io/v2"

    def get_signed_token(function_name, params, expires_in = 15)
      exp = Time.now.to_i + expires_in
      payload = { function: function_name, params: params, exp: exp }
      token = JWT.encode payload, @signing_secret, 'HS256', { :typ => "JWT", :kid => @cloud_name }

      return token
    end

    def get_headers(function_name, params)
      if(@signed)
        token = get_signed_token(function_name, params)
      else
        token = @api_key
      end

      return { 'Content-Type': 'application/json', 'X-Authorization' => token }
    end

    def get_response(function_name, url, payload = {})
      response = HTTParty.get("#{CLOUDPDF_API_ENDPOINT}#{url}", 
        timeout: 5, 
        headers: get_headers(function_name, payload)
      )
      body = JSON.parse(response.body)
      return {"error" => body['errorDescription'], "code" => response.code} if response.code >= 400
      return body
    end

    def delete_response(function_name, url, payload = {})
      response = HTTParty.delete("#{CLOUDPDF_API_ENDPOINT}#{url}", 
        timeout: 5, 
        headers: get_headers(function_name, payload)
      )
      body = JSON.parse(response.body)
      return {"error" => body['errorDescription'], "code" => response.code} if response.code >= 400
      return body
    end

    def patch_response(function_name, url, payload)
      response = HTTParty.patch("#{CLOUDPDF_API_ENDPOINT}#{url}", 
        body: payload.to_json,
        timeout: 5,
        headers: get_headers(function_name, payload)
      )
    	body = JSON.parse(response.body)
      return {"error" => body['errorDescription'], "code" => response.code} if response.code >= 400
      return body
    end

    def put_response(function_name, url, payload)
      response = HTTParty.put("#{CLOUDPDF_API_ENDPOINT}#{url}", 
        body: payload.to_json,
        timeout: 5,
        headers: get_headers(function_name, payload)
      )
    	body = JSON.parse(response.body)
      return {"error" => body['errorDescription'], "code" => response.code} if response.code >= 400
      return body
    end

    def post_response(function_name, url, payload)
      response = HTTParty.post("#{CLOUDPDF_API_ENDPOINT}#{url}", 
        body: payload.to_json,
        timeout: 5,
        headers: get_headers(function_name, payload)
      )
    	body = JSON.parse(response.body)
      return {"error" => body['errorDescription'], "code" => response.code} if response.code >= 400
      return body
    end

  end

end