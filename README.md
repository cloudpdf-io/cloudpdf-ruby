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

After uploading the file you must notify our server that the upload is finished and we will process the PDF by our PDF engine.

```ruby
cloudpdf.create_document({
  "name": "your_document_name.pdf",
  "description": "Description of your document",
  "defaultPermissions": {
    "download": "Allowed",
    "search": true
  }
})
```

##### Options

- `name`: the name of the PDF you want to upload (`string`)
- `description`: description of the PDF you want to upload (`string`)
- `parentId`: the ID of the folder you want to create the document in (`string`)
- `tags`: set tags on the document to easily filter and search documents later (`array`)
- `defaultPermissions`: Set the default permissions for this document. If none are given we use the default permissions of the organization. You can change the default permissions of the organization in the Dashboard → Settings → Upload Settings. (`object`)

#### Get a Document

```ruby
cloudpdf.get_document("DOCUMENT ID")
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cloudpdf-io/cloudpdf-ruby.

## License

The repository is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
