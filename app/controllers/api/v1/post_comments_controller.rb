module Api
  module V1
    class PostCommentsController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :set_post
      skip_before_action :verify_authenticity_token, only: [:create]

      def index
        comments = @post.comments
        render json: comments
      end

      def create
        random_user = User.order('RANDOM()').first
        comment = @post.comments.new(comment_params)
        comment.user = random_user

        if comment.save
          render json: comment, status: :created
        else
          puts "Error saving comment: #{comment.errors.full_messages}"
          render json: comment.errors, status: :unprocessable_entity
        end
      end

      private

      def set_post
        @post = Post.find_by(id: params[:post_id])

        return if @post

        render json: { error: 'Post not found' }, status: :not_found
      end

      def comment_params
        params.require(:comment).permit(:text)
      end

      # def current_user
      #   @current_user ||= User.find_by(confirmation_token: request.headers['Authorization']&.split(' ')&.last)
      # end
    end
  end
end
