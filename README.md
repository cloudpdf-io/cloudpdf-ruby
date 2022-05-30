# CloudPDF Ruby

Ruby wrapper for the [CloudPDF API](https://cloudpdf.io/developers/api-docs) - an cloud-based PDF management service. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudpdf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cloudpdf

## Usage

### Table of Contents

- [Authentication](#authentication)
- [Account Info](#account-info)
- [Documents](#documents)

### Authentication

Get the API key for your project from your CloudPDF Dashboard → Settings → API Keys.

```ruby
cloudpdf = CloudPDF::Client.new({:api_key => 'YOUR API KEY', :cloud_name => 'YOUR CLOUD NAME', :signing_secret => 'YOUR SIGNING SECRET'})
```

### Account Info

Return info about the Account associated with this API key.

```ruby
cloudpdf.account
```

### Documents

#### Create a Document

Before you can upload a PDF to CloudPDF you must create a new document.

The server will return a pre-signed upload URL where you can upload your PDF file.

After uploading the file you must [notify our server](#upload-file-completed) that the upload is finished and we will process the PDF by our PDF engine.

```ruby
cloudpdf.create_document({
  "name": "your_document_name.pdf",
  "description": "Description of your document",
  "tags": ["tag1", "tag2"],
  "defaultPermissions": {
    "download": "Allowed",
    "search": true,
    "selection" false,
    "info": ["email", "phone"]
  }
})
```

##### Options

- `name`: The name of the PDF you want to upload (`string`)
- `description`: Description of the PDF you want to upload (`string`)
- `parentId`: The ID of the folder you want to create the document in (`string`)
- `tags`: Set tags on the document to easily filter and search documents later (`array`)
- `defaultPermissions`: Set the default permissions for this document. You can find all parameters in te [API docs](https://cloudpdf.io/developers/api-docs#create-document). If none are given we use the default permissions of the organization. You can change the default permissions of the organization in the Dashboard → Settings → Upload Settings. (`object`)

#### Get a Document

```ruby
cloudpdf.get_document("DOCUMENT ID")
```

#### Update a Document

```ruby
cloudpdf.update_document("DOCUMENT ID", {
  "name": "your_document_name.pdf",
  "description": "Description of your document",
  "tags": ["tag1", "tag2"],
  "defaultPermissions": {
    "download": "Allowed",
    "search": true,
    "selection" false,
    "info": ["email", "phone"]
  }
})
```

##### Options

- `name`: The name of the PDF you want to upload (`string`)
- `description`: Description of the PDF you want to upload (`string`)
- `parentId`: The ID of the folder you want to create the document in (`string`)
- `tags`: Set tags on the document to easily filter and search documents later (`array`)
- `defaultPermissions`: Set the default permissions for this document. You can find all parameters in te [API docs](https://cloudpdf.io/developers/api-docs#update-document). If none are given we use the default permissions of the organization. You can change the default permissions of the organization in the Dashboard → Settings → Upload Settings. (`object`)

#### Delete a Document

```ruby
cloudpdf.delete_document("DOCUMENT ID")
```

#### Upload file completed

After uploading your file to Amazon S3 you must notify our server on this endpoint that the upload is complete. On a successful request the status of the document will change from "WaitingUpload" to "Processing".

You can poll the GET endpoint for status updates or use a webhook to find out if your document has completed processing by our PDF engine.

```ruby
cloudpdf.upload_document_file_complete("DOCUMENT ID", "FILE ID")
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cloudpdf-io/cloudpdf-ruby.

## License

The repository is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
