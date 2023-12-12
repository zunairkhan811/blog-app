require 'rails_helper'

RSpec.describe 'Post Index Page', type: :system do
  let(:user) do
    User.create(name: 'Tom', photo: 'https://unsplash.com/photos/F_-0BxGuVvo', bio: 'Teacher from Mexico.')
  end

  before do
    10.times do |i|
      post = user.posts.create(title: "Post #{i + 1}", text: "Content #{i + 1}")
      post.comments.create(user:, text: "Comment #{i + 1}")
      post.likes.create(user:)
    end
  end

  describe 'Post Index Page' do
    before { visit user_posts_path(user) }

    it 'shows the user profile picture' do
      expect(page).to have_css("img[src*='https://unsplash.com/photos/F_-0BxGuVvo']")
    end

    it 'shows the user username' do
      expect(page).to have_content('Tom')
    end

    it 'shows the number of posts the user has written' do
      expect(page).to have_content('Number of Posts: 10')
    end

    it 'shows a post\'s title' do
      expect(page).to have_content('Post 1')
    end

    it 'shows some of the post\'s body' do
      expect(page).to have_content('Content 1')
    end

    it 'shows the first comments on a post' do
      expect(page).to have_content('Comment 1')
    end

    it 'shows how many comments a post has' do
      expect(page).to have_content('Comments: 1')
    end

    it 'shows how many likes a post has' do
      expect(page).to have_content('Likes: 1')
    end

    it 'shows a section for pagination if there are more posts than fit on the view' do
      expect(page).to have_content('Pagination')
    end

    it 'redirects to the post show page when clicking on a post' do
      click_link 'Post 1'
      expect(page).to have_current_path(user_post_path(user, user.posts.first))
    end
  end
end
