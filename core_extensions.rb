class Array
		def all_empty?
			self.all? { |element| element.to_s.empty?}
		end
		
		#used to check for winning 4 pieces that are not empty on board
		def all_same?
			self.all? { |element| (element == self[0]) && (element != nil) }
		end
		
		def any_empty?
			self.any? { |element| element == nil}
		end
		
		def none_empty?
			!any_empty?
		end
				
		def rotate
			arr=self
			rotated = arr.transpose.reverse
			rotated
		end
end
