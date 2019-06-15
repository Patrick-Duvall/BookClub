class BooksController < ApplicationController
  # before_action :set_book, only: [:show, :destroy]

  def index

    case params[:sort]
      when 'pagesasc'     ; @books = Book.page_sort_asc
      when 'pagesdesc'    ; @books = Book.page_sort_desc
      when 'publishedasc' ; @books = Book.published_sort_asc
      when 'publisheddesc'; @books = Book.published_sort_desc
      when 'reviewsasc'   ; @books = Book.reviews_sort_asc
      when 'reviewsdesc'  ; @books = Book.reviews_sort_desc
      else ; @books = Book.all
    end

    @highest_3 =Book.highest_3_rated_titles
    @lowest_3 = Book.lowest_3_rated_titles
    @three_ratingest_users = User.three_ratingest_users
  end

  def show
    @book = Book.find(params[:id])
    @top_three_reviews = @book.reviews.top_three
    @bottom_three_reviews = @book.reviews.bottom_three
    @average_rating = @book.reviews.empty? ? 0 : @book.reviews.average_rating
  end

  def new
    @book = Book.new
  end

  def create
    authors = params[:book][:authors].split(',').map(&:titlecase)
    if book_params[:pages].to_i < 0 || book_params[:pages].match?(/[a-z]+/i)
      flash.notice = "Please Enter a Positive Number For Pages!"
      redirect_to new_book_path
      return
    end
    if Book.exists(book_params[:title])
      flash.notice = "That Book Already Exists!"
      redirect_to new_book_path
      return
    end
    @book = Book.new(book_params)
    @book.save
    authors.each do |author|
      this_author = Author.find_or_create_by(name: author)
      BookAuthor.create!(book: @book, author: this_author)
    end
    redirect_to book_path(@book)
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    new_params = params.require(:book).permit(:title, :pages, :published, :image_url)
    new_params[:title] = new_params[:title].titlecase
    new_params[:image_url] = 'https://timedotcom.files.wordpress.com/2015/06/521811839-copy.jpg' if new_params[:image_url] == ''
    new_params
  end

  # def set_book
  #   @book = Book.find(params[:id])
  # end

end
