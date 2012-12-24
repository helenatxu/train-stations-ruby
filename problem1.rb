class TrainStations
  def initialize()
    @routes = {}
  end

  def add_route(src, dst, dist)
    # FIXME: you can use the ||= operator instead
    # (http://www.rubyinside.com/what-rubys-double-pipe-or-equals-really-does-5488.html)
    @routes[src] = {} if @routes[src].nil?
    @routes[dst] = {}if @routes[dst].nil? # FIXME: space before if
    @routes[src][dst] = dist 
  end

  def distance(x,y) # FIXME: space after ,
    # FIXME: what is this for? why would anyone run this with x or y = nil?
    # FIXME: x and y are meaningless names
    return nil if x.nil? || y.nil?
    if !@routes.has_key?(x)
      return nil
    elsif @routes[x][y].nil? # FIXME: I don't think this is necessary
      return nil
    else
      return @routes[x][y]
    end
  end

  # FIXME: Ruby convention for naming is under_score, not camelCase
  def calcDist(a) # FIXME: a is a meaningless name
    i = 0 
    total = 0 
    dist = 0 # FIXME: this seems unnecessary
    # FIXME: use an iterator instead, e.g. 0.upto(a.length-1) do |i| ... end
    while i < a.length-1
      dist = distance a[i], a[i+1]
      i+=1
      if dist.nil?
        # FIXME: inconsistent return (only case when not returning an integer),
        # return nil instead or even better, raise an exception and catch it later
        return "NO SUCH ROUTE"
      # FIXME: no need for else when doing return
      else
        total += dist
      end      
    end
    # FIXME: no need for return when in last statement
    return total
  end

  # FIXME: naming convention (nobody who knows Ruby well uses camelCase)
  def exploreTripsMaxStops(node, destination, count) # FIXME: decide if you use src and dst or other names
    trips = 0
    if count > 0
      trips += 1 if node == destination 
      @routes[node].each do |n, v|
        trips += exploreTripsMaxStops(n, destination, count-1)
      end
    end
    trips
  end

  # FIXME: naming convention
  def exploreTripsMaxLength(node, destination, count) # FIXME: decide if you use src and dst or other names
    trips = 0
    @routes[node].each do |n, v|
      if v < count
        trips += 1 if n == destination
        trips += exploreTripsMaxLength(n, destination, count-v)
      end
    end
    trips
  end

  # FIXME: naming convention
  def countTripsInStop(node, destination, count) # FIXME: decide if you use src and dst or other names
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

  # FIXME: naming convention
  def shortestRouteToSameStation(origin) # FIXME: decide, origin or src
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

###   OUTPUT  ### FIXME: this comment looks ugly ;)
puts "Output #1", stations.calcDist(["A","B","C"])           #1. The distance of the route A­B­C.
puts "Output #2", stations.calcDist(["A","D"])               #2. The distance of the route A­D.
puts "Output #3", stations.calcDist(["A","D","C"])           #3. The distance of the route A­D­C.
puts "Output #4", stations.calcDist(["A","E", "B","C", "D"]) #4. The distance of the route A­E­B­C­D. 
puts "Output #5", stations.calcDist(["A","E","D"])           #5. The distance of the route A­E­D.
puts "Output #6", stations.exploreTripsMaxStops("C", "C", 3) #6.
puts "Output #7", stations.countTripsInStop("A", "C", 4)     #7.
puts "Output #8", stations.dijkstra("A", "C")                #8.
puts "Output #9", stations.shortestRouteToSameStation("B")   #9. The length of the shortest route (in terms of distance to travel) from B to B.
puts "Output #10", stations.exploreTripsMaxLength("C", "C", 30) #10. FIXME: not aligned

# FIXME: IMPORTANT, your output is incorrect. This command:
#
#     $ diff -s output.txt <(ruby problem1.rb < input.txt)
#
# should say that files are identical.
