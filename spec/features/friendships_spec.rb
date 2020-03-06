RSpec.describe 'Friendship feature', type: :feature do
  let(:user_valid) do
    has_x = { name: 'elijah', email: 'elijah@gmail.com' }
    has_x[:password] = 'elijah'
    has_x[:password_confirmation] = 'elijah'

    has_x
  end

  let(:user_valid) do
    has_x = { name: 'jay', email: 'jay@gmail.com' }
    has_x[:password] = 'jayjay'
    has_x[:password_confirmation] = 'jayjay'

    has_x
  end

  let(:user_valid3) do
    has_x = { name: 'micro', email: 'micro@email.com' }
    has_x[:password] = 'microverse'
    has_x[:password_confirmation] = 'microverse'
    has_x
  end

  scenario 'view only friends posts on timeline' do
    user = User.create(user_valid)
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user_valid[:password]
    click_button 'Log in'

    user2 = User.create(user_valid2)

    Friendship.create(user_id: user.id, friend_id: user2.id, confirmed: true)
    Friendship.create(user_id: user2.id, friend_id: user.id, confirmed: true)

    user3 = User.create(user_valid3)

    post1 = user.posts.create(content: 'this is a post')
    post2 = user2.posts.create(content: '2 this is a post 2')

    post3 = user3.posts.create(content: '3 this is a post 3')

    visit root_path

    expect(page).to have_content post1.content
    expect(page).to have_content post2.content
  end
  
end