require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # Replace this with your real tests.
  test "product attribute must not be empty" do
	product = Product.new
	assert product.invalid?
	assert product.errors[:title].any?
	assert product.errors[:decription].any?
	assert product.errors[:price].any?
	assert product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
	product = Product.new (:title		=> "My book title",
						   :decription 	=> "yyy",
						   :image_url	=> "zzz.jpg")
	product.price = -1
	assert product.invalid?
	assert_equal "must be greater than or equal to 0.01",
		product.errors[:price].join('; ')
	
	product.price =1
	assert product.valid?
	end
	
  def new_product(image_url)
	Product.new (:title			=> "My book title",
				 :decription 	=> "yyy",
				 :price			=> 1,
			     :image_url		=> image_url)
  end
  
  test "image url" do 
   ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
   bad= %w{ fred.doc fred.gif/more fred.gif.more }
	ok.each do |name|
		assert new_product(name).valid?, "#{name} shouldnt be invalid"
	end
	bad.each do |name|
		assert new_product(name).invalid?, "#{name} shouldnt be valid"
	end
   end
   
  test "product is not valid without a unique title" do
	product = Product.new(	:title		=> products(:ruby).title,
							:decription	=> "yyy",
							:price		=> 1,
							:image_url	=> "fred.gif")
	assert !product.save
	assert_equal "has already been taken", product.errors[:title].join('; ')
  end
end

