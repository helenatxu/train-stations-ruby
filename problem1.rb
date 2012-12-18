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
    if !@routes.has_key?(x)
      return nil
    elsif @routes[x][y].nil?
      return nil
    else
      return @routes[x][y]
    end
  end

  def calcDist (a)
    i = 0 
    total = 0 
    dist = 0
    while i < a.length-1
      dist = distance a[i], a[i+1]
      i+=1
      if dist.nil?
        return "NO SUCH ROUTE"
      else
        total += dist
      end      
    end
    return total
    puts "\n"
  end

  def exploreTripsMaxStops(node, destination, count, trips)
    if count === 0
      return trips
    elsif node == destination 
      trips += 1
    end
    @routes[node].each do |n, v|
      return exploreTripsMaxStops(n, destination, count-1, trips)
    end
  end

  def countTripsUntilMax(origin, destination, maxStops)
    #TODO validar nulls, etc
    trips = 0
    puts " Origin: ", origin, @routes[origin]
    puts " Destination: ", destination, @routes[destination]

    @routes[origin].each do |node, value|
      trips += exploreTripsMaxStops(node, destination, maxStops, 0)
    end
    puts "Final: "
    puts trips
    return trips
  end


  def countTripsInStop(node, destination, count)
    if count === 0      
      if node == destination 
        return 1
      end
      return 0
    end
    trips = 0
    @routes[node].each do |n, v|
      trips += countTripsInStop(n, destination, count-1)
    end
    trips
  end


end


stations = TrainStations.new


###   TESTS  ###
puts "\n"

# stations.calcDist ["A","B","C"]           #1. The distance of the route A­B­C.
# stations.calcDist ["A","D"]               #2. The distance of the route A­D.
# stations.calcDist ["A","D","C"]           #3. The distance of the route A­D­C.
# stations.calcDist ["A","E", "B","C", "D"] #4. The distance of the route A­E­B­C­D. 
# stations.calcDist ["A","E","D"]           #5. The distance of the route A­E­D.

#stations.countTripsUntilMax "C", "C", 3  #6.
puts stations.countTripsInStop("A", "C", 4)  #7.