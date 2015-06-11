# coding: utf-8
class TopController < ApplicationController
  skip_before_action :authenticate

  # トップ
  def index
    render 'my/index' if signed_in?
  end
end
