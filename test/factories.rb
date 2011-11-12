require 'factory_girl'

#taken from https://gist.github.com/162881
module FactoryGirl
  class DefinitionProxy
    def attachment(name, path, content_type = nil)
      path_with_rails_root = "#{::Rails.root.to_s}/#{path}"
      uploaded_file = if content_type
                        Rack::Test::UploadedFile.new(path_with_rails_root, content_type)
                      else
                        Rack::Test::UploadedFile.new(path_with_rails_root)
                      end

      add_attribute name, uploaded_file
    end
  end
end

Factory.define :leaf do |f|
  f.name "Anonymous"
  f.content "Hi I'm making a post."
  f.attachment(:photo, "test/fixtures/forttree.png", "image/x-png")
end

Factory.define :branch do |f|
  f.after_create do |ff|
    ff.leafs = []
    ff.leafs << Factory.create(:leaf, :branch => ff)
  end
end
