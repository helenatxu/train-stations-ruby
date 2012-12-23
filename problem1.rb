class TrainStations
  def initialize()
    @routes = {}
  end

  def add_route(src, dst, dist)
    @routes[src] = {} if @routes[src].nil?
    @routes[dst] = {}if @routes[dst].nil?
    @routes[src][dst] = dist 
  end

  def distance(x,y)
    return nil if x.nil? || y.nil? 
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
  end

  def exploreTripsMaxStops(node, destination, count)
    trips = 0
    if count > 0
      trips += 1 if node == destination 
      @routes[node].each do |n, v|
        trips += exploreTripsMaxStops(n, destination, count-1)
      end
    end
    trips
  end

  def exploreTripsMaxLength(node, destination, count)
    trips = 0
    @routes[node].each do |n, v|
      if v < count
        trips += 1 if n == destination
        trips += exploreTripsMaxLength(n, destination, count-v)
      end
    end
    trips
  end

  def countTripsInStop(node, destination, count)
    if count === 0      
      return 1 if node == destination 
      return 0
    end
    trips = 0
    @routes[node].each do |n, v|
      trips += countTripsInStop(n, destination, count-1)
    end
    trips
  end

  def dijkstra(src, dst = nil)
    distances = {}
    unvisited = []
    @routes.keys.each do |node| 
      distances[node] = Float::INFINITY
      unvisited << node 
    end
    distances[src] = 0
    current = src

    until unvisited.empty? || distances[current] == Float::INFINITY
      unvisited_distances = distances.select { |node, dist| unvisited.include?(node) }
      current = unvisited_distances.min_by { |node, dist| dist }.first

      if @routes[current]
        @routes[current].each do |node, dist|
          tentative_dist = distances[current] + dist
          distances[node] = tentative_dist if tentative_dist < distances[node]
        end
      end
      unvisited.delete(current)

      return distances[current] if dst && current == dst
    end

    distances
  end

  def shortestRouteToSameStation(origin)
    shortRoute = dijkstra(origin)
    shortRoute.each do |n, v| 
      shortRoute[n] += dijkstra(n, origin) unless v.nil?
      shortRoute.delete(n) if n == origin || v.nil?
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

###   OUTPUT  ###
puts "Output #1", stations.calcDist(["A","B","C"])           #1. The distance of the route A­B­C.
puts "Output #2", stations.calcDist(["A","D"])               #2. The distance of the route A­D.
puts "Output #3", stations.calcDist(["A","D","C"])           #3. The distance of the route A­D­C.
puts "Output #4", stations.calcDist(["A","E", "B","C", "D"]) #4. The distance of the route A­E­B­C­D. 
puts "Output #5", stations.calcDist(["A","E","D"])           #5. The distance of the route A­E­D.
puts "Output #6", stations.exploreTripsMaxStops("C", "C", 3) #6.
puts "Output #7", stations.countTripsInStop("A", "C", 4)     #7.
puts "Output #8", stations.dijkstra("A", "C")                #8.
puts "Output #9", stations.shortestRouteToSameStation("B")   #9. The length of the shortest route (in terms of distance to travel) from B to B.
puts "Output #10", stations.exploreTripsMaxLength("C", "C", 30) #10.
