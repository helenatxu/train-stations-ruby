class TrainStations

  def initialize
    input = gets.split(",").map { |route| route.strip }
    @routes = {}
    input.each do |i| 
      if @routes[i[0]].nil?
        @routes[i[0]] = {}
      end
      @routes[i[0]][i[1]] = i[2..-1].to_i  
      # so it will take all digits in case the route length > 9
    end
    puts @routes
  end

  def distance (x,y)
    if x.nil? || y.nil? 
      return nil
    end

    puts x 
    puts " <--- X"
    puts y
    puts " <--- Y"

    if !@routes.has_key?(x)
      return nil
    elsif @routes[x][y].nil?
      return nil
    else
      puts @routes[x][y]
      puts " <--- @routes[x][y] \n"
      return @routes[x][y]
    end
  end


  def calc_dist (a)
    i = 0 
    total = 0 
    dist = 0
    #TODO mejorar con yield
    puts a
    puts a.length
    puts "--------"
    while i < a.length-1
      puts i   
      puts " <--- i"

      dist = distance a[i], a[i+1]
      i+=1
      if dist.nil?
        return "NO SUCH ROUTE"
      else
        total += dist
      end      
    end
    puts "Total: " + total.to_s
    return total
    
  end


end

stations = TrainStations.new


###   TESTS  ###
puts "\n"

# puts stations.calc_dist ["A","B","C"]
# puts stations.calc_dist ["A","C"]
# puts stations.calc_dist ["A","Z"]
# puts stations.calc_dist [nil,"B","C"]
puts stations.calc_dist ["1","B","C"]
puts stations.calc_dist ["A","B","C","D","E"]
puts stations.calc_dist ["A","B","C","D","C"]
