class TrainStations
  def initialize()
    @routes = {}
  end

  def add_route(src, dst, dist)
      if @routes[src].nil?
        @routes[src] = {}
      end
      if @routes[dst].nil?
        @routes[dst] = {}
      end
      @routes[src][dst] = dist  
      # so it will take all digits in case the route length > 9

    puts @routes
  end

  def distance(x,y)
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

  def calcDist(a)
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

  def exploreTripsMaxStops(node, destination, count)
    trips = 0
    if count > 0
      if node == destination 
        trips += 1
      end
      @routes[node].each do |n, v|
        trips += exploreTripsMaxStops(n, destination, count-1)
      end
    end
    trips
  end

  def exploreTripsMaxLength(node, destination, count)
    trips = 0
    @routes[node].each do |n, v|
      puts "-------", n, v,  count, "-------"
      if v < count
        trips += 1 if n == destination
        trips += exploreTripsMaxLength(n, destination, count-v)
      end
    end
    trips
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

  def dijkstra(src)
    distances = {}
    unvisited = []
    puts "ROUTES -- ", @routes
    @routes.keys.each do |node| 
      distances[node] = Float::INFINITY
      unvisited << node 
    end
        puts "\n\n-- Distances: ", distances

    distances[src] = 0
    #unvisited.delete(src)
    current = src

    puts "\n\n-- Distances: ", distances

    until unvisited.empty? || distances[current] == Float::INFINITY
      if @routes[current]
        @routes[current].each do |node, dist|
          tentative_dist = distances[current] + dist
          distances[node] = tentative_dist if tentative_dist < distances[node]
              puts "\n\n-- Distances: ", distances

        end
      end
    puts "\n\n-- Distances: ", distances

      unvisited.delete(current)
      unvisited_distances = distances.select { |node, dist| unvisited.include?(node) }
      puts "\n\n-- unvisited_distances: ", unvisited_distances
      puts "\n\n-- unvisited: ", unvisited
      current = unvisited_distances.min_by { |node, dist| dist }.first
    end

    distances
  end

  def shortestRouteToSameStation(origin)
    shortRoute = dijkstra(origin)
    shortRoute.each do |n, v| 
      if not v.nil?
        shortRoute[n] += dijkstra(n, origin)
      end
      if n == origin || v.nil?
        shortRoute.delete(n)
      end
    end
    return shortRoute.values.min
  end


end


stations = TrainStations.new
input = gets.split(",").map { |route| route.strip }
input.each do |route|
  src = route[0]
  dst = route[1]
  dist = route[2..-1].to_i
  stations.add_route(src, dst, dist)
end

###   TESTS  ###
puts "\n\n\n"


#puts "Output #8", stations.dijkstra("A", "C"), "\n\n\n"
puts "Output #9", stations.dijkstra("A"), "\n\n\n"



# puts stations.calcDist ["A","B","C"]           #1. The distance of the route A­B­C.
# puts stations.calcDist ["A","D"]               #2. The distance of the route A­D.
# puts stations.calcDist ["A","D","C"]           #3. The distance of the route A­D­C.
# puts stations.calcDist ["A","E", "B","C", "D"] #4. The distance of the route A­E­B­C­D. 
# puts stations.calcDist ["A","E","D"]           #5. The distance of the route A­E­D.
# puts stations.exploreTripsMaxStops "C", "C", 3 #6.
# puts stations.countTripsInStop("A", "C", 4)    #7.

#puts "Output #10", stations.exploreTripsMaxLength("C", "C", 30)

#stations = Graph.new

# ("A".."E").each {|node| stations.push node }
# input.each do |i|
#   stations.connect_directed i[0], i[1], i[2..-1].to_i
# end

# puts "Output #8", stations.neighbors("A")

#puts "Output #8", stations.dijkstra("A", "C") #8. The length of the shortest route (in terms of distance to travel) from A to C.
#puts "Output #9", stations.shortestRouteToSameStation("B") #9. The length of the shortest route (in terms of distance to travel) from B to B.


# p stations
# p stations.length_between("A", "B")
# p stations.neighbors("A")
# p stations.dijkstra("A", "C")

