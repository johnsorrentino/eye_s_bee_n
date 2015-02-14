module ISBN

  # http://stackoverflow.com/a/14096142/3224822
  def self.parse(isbn)
    isbn = isbn.gsub(/x/, 'X')                                    # Use capital X
    isbn = isbn.gsub(/[^0-9X]/, '')                               # Whitelist characters
    isbn = isbn[/\b(?:ISBN(?:: ?| ))?((?:97[89])?\d{9}[\dx])\b/i] # Extract
    return isbn if valid?(isbn)
  end

  def self.valid?(isbn)
    return false if isbn.nil?
    if isbn.length == 10
      isbn[9] == calculate_isbn_10_check_digit(isbn)
    elsif isbn.length == 13
      isbn[12] == calculate_isbn_13_check_digit(isbn)
    else
      false
    end
  end

  def self.convert_isbn_10_to_isbn_13(isbn)
    '978' + isbn[0..8] + calculate_isbn_13_check_digit('978' + isbn[0..8])
  end

  def self.convert_isbn_13_to_isbn_10(isbn)
    isbn[3..11] + calculate_isbn_13_check_digit(isbn)
  end

  # http://www.hahnlibrary.net/libraries/isbncalc.html
  def self.calculate_isbn_10_check_digit(isbn)
    array_1 = isbn[0..8].split('').map(&:to_i)
    array_2 = Array(1..9)
    modulo = sum_product(array_1, array_2) % 11
    modulo == 10 ? 'X' : modulo.to_s
  end

  # http://www.hahnlibrary.net/libraries/isbncalc.html
  def self.calculate_isbn_13_check_digit(isbn)
    array_1 = isbn[0..11].split('').map(&:to_i)
    array_2 = [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3]
    modulo = sum_product(array_1, array_2) % 10
    modulo.to_s
  end

  # Fastest sum product: http://stackoverflow.com/a/7373434/3224822
  def self.sum_product(array_1, array_2)
    sum = 0
    index = 0
    size = array_1.size
    while index < size
      sum += array_1[index] * array_2[index]
      index += 1
    end
    sum
  end

end