class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(eth_address: params[:eth_address])
    if @user.present? && params[:eth_signature]
      message   = params[:eth_message]
      signature = params[:eth_signature]

      custom_title, request_time, signed_nonce = message.split(",")
      request_time = Time.at(request_time.to_f / 1000.0)
      expiry_time = request_time + 300
      # make sure the parsed request_time is sane
      # (not nil, not 0, not off by orders of magnitude)
      sane_checkpoint = Time.parse("2022-01-01 00:00:00 UTC")
      if request_time and request_time > sane_checkpoint and Time.now < expiry_time
        if signed_nonce.eql?(@user.eth_nonce)
          # recover address from signature
          signature_pubkey = Eth::Signature.personal_recover(message, signature)
          signature_address = Eth::Util.public_key_to_address(signature_pubkey)
          # if the recovered address matches the user address on record, proceed
          # (uses downcase to ignore checksum mismatch)
          if @user.eth_address.downcase.eql?(signature_address.to_s.downcase)
            # if this is true, the user is cryptographically authenticated!
            session[:user_id] = @user.id
            # rotate the random nonce to prevent signature spoofing
            @user.eth_nonce = get_new_nonce
            @user.save!
            redirect_to root_path, notice: "Logged in successfully!"
          end
        end
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out."
  end
end
