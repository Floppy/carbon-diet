class CaptchaController < ApplicationController

  include Captcha

  def image
    # Get captcha string
    captchatext = generate_captcha_word(params[:seed])

    send_data generate_captcha_image(captchatext).to_blob, 
              :filename => "captcha.png", 
              :disposition => 'inline', 
              :type => "image/png"
  end

end
