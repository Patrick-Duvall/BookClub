
# As a Visitor,
# When I visit a book index page,
# I see all book titles in the database.
# Each book entry on the page shows the author(s) and number of
# pages in the book, and the year it was published.
require "rails_helper"

describe "as a visitor" do
  describe 'I visit book index page' do

    before :each do
      @book_1 = Book.create!(title: 'Book 1', published: 1955, pages: 155)
      @book_2 = Book.create!(title: 'Book 2', published: 1965, pages: 245)
      @book_3 = Book.create!(title: 'Book 3', published: 1975, pages: 33)
      @author_1 = Author.create!(name: 'Author 1')
      @author_2 = Author.create!(name: 'Author 2')
      @author_3 = Author.create!(name: 'Author 3')
      BookAuthor.create!(book: @book_1, author: @author_1)
      BookAuthor.create!(book: @book_1, author: @author_2)
      BookAuthor.create!(book: @book_2, author: @author_2)
      BookAuthor.create!(book: @book_3, author: @author_3)
      @user_1 = User.create!(name: "User 1")
      @user_2 = User.create!(name: "User 2")
      @user_3 = User.create!(name: "User 3")
      @review_1 = Review.create!(title: 'Review 1', rating: 2, body: 'content 1', book: @book_1, user: @user_1)
      @review_2 = Review.create!(title: 'Review 2', rating: 3, body: 'content 2', book: @book_1, user: @user_2)
      @review_3 = Review.create!(title: 'Review 3', rating: 4, body: 'content 3', book: @book_1, user: @user_3)
      @review_4 = Review.create!(title: 'Review 4', rating: 5, body: 'content 4', book: @book_2, user: @user_1)
      @review_5 = Review.create!(title: 'Review 5', rating: 2, body: 'content 5', book: @book_2, user: @user_2)
      @review_6 = Review.create!(title: 'Review 6', rating: 3, body: 'content 6', book: @book_2, user: @user_3)
    end

    it "displays book informtaion" do

      visit books_path

        within("#book-#{@book_1.id}")  do
          expect(page).to have_content(@book_1.title)
          expect(page).to have_content(@author_1.name)
          expect(page).to have_content(@author_2.name)
          expect(page).to have_content("Page Count: #{@book_1.pages}")
          expect(page).to have_content("Published In: #{@book_1.published}")
      end

        within("#book-#{@book_2.id}")  do
          expect(page).to have_content(@book_2.title)
          expect(page).to have_content(@author_2.name)
          expect(page).to have_content("Page Count: #{@book_2.pages}")
          expect(page).to have_content("Published In: #{@book_2.published}")
      end

        within("#book-#{@book_3.id}")  do
          expect(page).to have_content(@book_3.title)
          expect(page).to have_content(@author_3.name)
          expect(page).to have_content("Page Count: #{@book_3.pages}")
          expect(page).to have_content("Published In: #{@book_3.published}")
      end

    end


    it 'displays average book rating' do

      visit books_path
      # Book.first.review_average

      within("#book-#{@book_1.id}")  do
        expect(page).to have_content("Average Review: 3.0")
        expect(page).to have_content("Total Reviews: 3")
      end

      within("#book-#{@book_2.id}")  do

        expect(page).to have_content("Average Review: 3.33")
        expect(page).to have_content("Total Reviews: 3")
      end


    end

    it 'sorts all books' do

      visit books_path

      click_link 'Page Count Asc'


      expect(page.all('.books')[0]).to have_content(@book_3.title)
      expect(page.all('.books')[1]).to have_content(@book_1.title)
      expect(page.all('.books')[2]).to have_content(@book_2.title)

      click_link 'Page Count Desc'
      save_and_open_page
      # require "pry"; binding.pry
      expect(page.all('.books')[0]).to have_content(@book_2.title)
      expect(page.all('.books')[1]).to have_content(@book_1.title)
      expect(page.all('.books')[2]).to have_content(@book_3.title)

    end

  end
end
