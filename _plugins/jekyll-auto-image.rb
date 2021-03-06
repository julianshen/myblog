#
# Copyright (c) 2015 Juan M. Merlos (@merlos) jekyll-auto-image
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


require "jekyll"

module Jekyll
 
  #
  # Auto Image Generator
  # 
  # Sets {{page.image}} variable in liquid with the following fallback:
  #  
  #  1) image value in front matter
  #  2) first image in the post/pàge
  #  3) _config.yaml image default
  #  4) nothing (not set)
  #
  #  
  class AutoImageGenerator < Generator
 
    def generate(site)
      @site = site
      
      site.pages.each do |page|
        img = get_image(page)
        page.data['image1'] = img if img
      end
      # Now do the same with posts
      site.posts.docs.each do |post|
        #puts "hola"
        #puts Jekyll::VERSION
        #puts post.class
        #puts post.inspect
        #puts post.data.inspect
        #puts "-----"      
        #puts post.output
        #puts "----"
        img = get_image(post)
        post.data['thumb'] = img if img
      end
    end # generate
    
    #
    # page: is either a Jekyll::Page or a Jekyll::post
    # returns the path of the first image found in the contents
    # of the page/post 
    #
    def get_image(page)
      
      # debug lines
      #puts page.title
      #puts page.name
      #puts page.ext
      #puts @site.converters.select { |c| c.matches(page.ext) }.sort
      if page.data['thumb']
        return page.data['thumb']
      end
      # convert the contents to html, and extract the first <img src="" apearance
      # I know, it's not efficient, but rather easy to implement :)
      
      if page.class == Jekyll::Document # for jekyll 3.0 posts & collections
        htmled = Jekyll::Renderer.new(@site, page, @site.site_payload).convert(page.content)
      else 
        htmled = page.transform # for jekyll 2.x pages
      end
      
      img_url = htmled.match(/<img.*\ssrc=[\"\']([\S.]+)[\"\']/i)
      if img_url != nil 
        iurl = img_url[1]
        if iurl.match(/^http/)
          return iurl
        else
          return @site.config['url'] + iurl
        end
      end

      tags = page.data['tags']
      imagemap = @site.config['imagemap']
      if tags != nil && imagemap != nil
        tags.each do |t|
          if imagemap[t.downcase] != nil
            url = imagemap[t.downcase]

            if !url.match(/^http/)
              url = @site.config['url'] + '/images/' + url
            end
            return url
          end
        end
      end

      return @site.config['logo'] if @site.config['logo'] != nil
      return nil
    end
    
  end # class
end # module