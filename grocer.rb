require 'pry' 
def find_item_by_name_in_collection(name, collection)
  
  my_index = 0 
  while my_index < collection.length do 
    if collection[my_index][:item] == name 
       return collection[my_index]
    end
    my_index += 1 
  end
  nil 
end

def consolidate_cart(cart)

  new_cart = []
  my_index = 0 
  
  while my_index < cart.length do 
    new_cart_item = find_item_by_name_in_collection(cart[my_index][:item], new_cart)
    binding.pry
    if new_cart_item 
       new_cart_item[:count] += 1
    else
      new_cart_item = {
        :item => cart[my_index][:item],
        :price => cart[my_index][:price],
        :clearance => cart[my_index][:clearance],
        :count => 1 
      }
      new_cart << new_cart_item
    end
    my_index += 1 
  end
  new_cart 
end

def apply_coupons(cart, coupons)
  counter = 0 
  while counter < coupons.length 
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    if cart_item && cart_item[:count] >= coupons[counter][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[counter][:num]
        cart_item[:count] -= coupons[counter][:num]
      else
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupons[counter][:cost] / coupons[counter][:num],
          :count => coupons[counter][:num],
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[counter][:num]
      end
    end
    counter += 1 
  end
  cart 
  # REMEMBER: This method **should** update cart
end

def apply_clearance(cart)
  counter = 0 
  while counter < cart.length
    if cart[counter][:clearance]
      cart[counter][:price] -= (cart[counter][:price] * 0.2).round(2)
    end
    counter += 1 
  end
  cart 
  
  # REMEMBER: This method **should** update cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  
  total = 0 
  counter = 0 
  while counter < final_cart.length
    total += final_cart[counter][:price] * final_cart[counter][:count]
    counter += 1 
  end 
  if total > 100 
    total -= (total * 0.10)
  end
  total 
  
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers)
end
