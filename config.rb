###
# Compass
###

compass_config do |config|
  config.output_style = :expanded
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

helpers do
  def image_tag(path, params={})
    if !params.has_key?(:"data-width") && !params.has_key?(:"data-height") && !path.include?("://")
      params[:alt] ||= ""

      real_path = path
      real_path = File.join(images_dir, real_path) unless real_path.start_with?('/')
      full_path = File.join(source_dir, real_path)

      if File.exists?(full_path)
        begin
          width, height = ::FastImage.size(full_path, :raise_on_failure => true)
          params[:"data-width"]  = width
          params[:"data-height"] = height
        rescue FastImage::UnknownImageType
          # No message, it's just not supported
        rescue
          warn "Couldn't determine dimensions for image #{path}: #{$!.message}"
        end
      end
    end

    super(path, params)
  end
end

activate :syntax
set :markdown_engine, :redcarpet

set :css_dir,    "css"
set :js_dir,     "js"
set :images_dir, "img"

configure :build do
  ignore "img/content/*"
  ignore "img/favicon/*"
  ignore "img/footer/*"
  ignore "img/global/*"
  ignore "img/head/*"
  ignore "img/src/*"
  ignore "js/src/*"
  ignore "css/src/*"
  ignore "partials/*"
  
  require "yui/compressor"
  activate :minify_css
  set :css_compressor, ::YUI::CssCompressor.new

  require "closure-compiler"
  activate :minify_javascript
  set :js_compressor, ::Closure::Compiler.new

  activate :minify_html

  activate :imageoptim do |options|
    options.verbose = true
    options.nice    = true
    options.threads = true

    options.image_extensions = [".png", ".jpg", ".gif"]

    options.pngcrush_options  = {:chunks => ["alla"], :fix => true, :brute => false}
    options.pngout_options    = false
    options.optipng_options   = {:level => 7, :interlace => false}
    options.advpng_options    = {:level => 4}
    options.jpegoptim_options = {:strip => ["all"], :max_quality => 90}
    options.jpegtran_options  = {:copy_chunks => false, :progressive => true, :jpegrescan => true}
    options.gifsicle_options  = {:interlace => false}
  end

  activate :relative_assets
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method       = :git
  deploy.remote       = "live"
  deploy.branch       = "master"
end
