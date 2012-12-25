class TrainStations
  def initialize()
    @routes = {}
  end

  def add_route(src, dst, dist)
    # FIXME: you can use the ||= operator instead
    # (http://www.rubyinside.com/what-rubys-double-pipe-or-equals-really-does-5488.html)
    @routes[src] = {} if @routes[src].nil?
    @routes[dst] = {} if @routes[dst].nil?
    @routes[src][dst] = dist 
  end


  def distance(src, dst)
    return nil unless @routes.has_key?(src)
    @routes[src][dst]
  end


  def calc_Dist(path)
    total = 0
    0.upto(path.length-2) do |i|
      dist = distance(path[i], path[i+1])
      return "NO SUCH ROUTE"  if dist.nil?
      total += dist
    end
    total
  end


  def explore_trips_max_stops(src, dst, stops)
    trips = 0
    if stops > 0
      trips += 1 if src == dst 
      @routes[src].each do |n, v|
        trips += explore_trips_max_stops(n, dst, stops-1)
      end
    end
    trips
  end


  def count_trips_in_stop(src, dst, stops)
    if stops === 0      
      return 1 if src == dst 
      return 0
    end
    trips = 0
    @routes[src].each do |n, v|
      trips += count_trips_in_stop(n, dst, stops-1)
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


  def shortest_route_to_same_station(origin)
    shortRoute = dijkstra(origin)
    shortRoute.each do |n, v| 
      shortRoute[n] += dijkstra(n, origin) unless v.nil?
      shortRoute.delete(n) if n == origin || v.nil?
    end
    return shortRoute.values.min
  end


  def explore_trips_max_length(src, dst, length)
    trips = 0
    @routes[src].each do |n, v|
      if v < length
        trips += 1 if n == dst
        trips += explore_trips_max_length(n, dst, length-v)
      end
    end
    trips
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
puts "Output #1: #{stations.calc_Dist(["A", "B", "C"])}"
#1. The distance of the route A­B­C.
puts "Output #2: #{stations.calc_Dist(["A", "D"])}"
#2. The distance of the route A­D.
puts "Output #3: #{stations.calc_Dist(["A", "D", "C"])}"         
#3. The distance of the route A­D­C.
puts "Output #4: #{stations.calc_Dist(["A", "E", "B", "C", "D"])}"
#4. The distance of the route A­E­B­C­D. 
puts "Output #5: #{stations.calc_Dist(["A", "E", "D"])}"      
#5. The distance of the route A­E­D.
puts "Output #6: #{stations.explore_trips_max_stops("C", "C", 3)}"
#6.
puts "Output #7: #{stations.count_trips_in_stop("A", "C", 4)}"
#7.
puts "Output #8: #{stations.dijkstra("A", "C")}"
#8.
puts "Output #9: #{stations.shortest_route_to_same_station("B")}"
#9. The length of the shortest route (distance to travel) from B to B.
puts "Output #10: #{stations.explore_trips_max_length("C", "C", 30)}"
#10. FIXME: not aligned

# FIXME: IMPORTANT, your output is incorrect. This command:
#
#     $ diff -s output.txt <(ruby problem1.rb < input.txt)
#
# should say that files are identical.
