class TrainStations
  def initialize(input)
    #input = gets.split(",").map { |route| route.strip }
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




class Edge
  attr_accessor :src, :dst, :length

  def initialize(src, dst, length)
    @src = src
    @dst = dst
    @length = length
  end
end

class Graph < Array
  attr_reader :edges

  def initialize
    @edges = []
  end

  def connect(src, dst, length)
    unless self.include?(src)
      raise ArgumentException, "No such vertex: #{src}"
    end
    unless self.include?(dst)
      raise ArgumentException, "No such vertex: #{dst}"
    end
    @edges.push Edge.new(src, dst, length)
  end

  def connect_directed(vertex1, vertex2, length)
    self.connect vertex1, vertex2, length
  end

  def neighbors(vertex)
    neighbors = []
    @edges.each do |edge|
      neighbors.push edge.dst if edge.src == vertex
    end
    return neighbors.uniq
  end

  def length_between(src, dst)
    @edges.each do |edge|
      if edge.src == src and edge.dst == dst
        return edge.length 
      end
      nil
    end
  end

  def dijkstra(src, dst = nil)
    distances = {}
    previouses = {}
    self.each do |vertex|
      distances[vertex] = nil # Infinity
      previouses[vertex] = nil
    end
    distances[src] = 0
    vertices = self.clone
    until vertices.empty? #### ---> por alguna razon, si scr==dst no encuentra otros nodos
      nearest_vertex = vertices.inject do |a, b|
        puts "=----", "a - ", a, "b - ", b, "distances[a]", distances[a], "distances[b]", distances[b], "\n--\n"
        next b unless distances[a]
        next a unless distances[b]
        next a if distances[a]<distances[b] && distances[a]>0
        b
      end  
      puts "nearest_vertex: ", nearest_vertex, "----"
      break unless distances[nearest_vertex] # Infinity
      if dst and nearest_vertex == dst
        puts "dest: ", dst, "distances: ", distances
        return distances[dst]
      end
      neighbors = vertices.neighbors(nearest_vertex)
      neighbors.each do |vertex|
        alt = distances[nearest_vertex] + vertices.length_between(nearest_vertex, vertex)
        if distances[vertex].nil? or alt < distances[vertex]
          distances[vertex] = alt
          previouses[vertices] = nearest_vertex
        end
      end
      vertices.delete nearest_vertex
    end
    if dst
      return nil
    else
      return distances
    end
  end

end


input = gets.split(",").map { |route| route.strip }

stations = TrainStations.new(input)

###   TESTS  ###
puts "\n"

# puts stations.calcDist ["A","B","C"]           #1. The distance of the route A­B­C.
# puts stations.calcDist ["A","D"]               #2. The distance of the route A­D.
# puts stations.calcDist ["A","D","C"]           #3. The distance of the route A­D­C.
# puts stations.calcDist ["A","E", "B","C", "D"] #4. The distance of the route A­E­B­C­D. 
# puts stations.calcDist ["A","E","D"]           #5. The distance of the route A­E­D.
# puts stations.exploreTripsMaxStops "C", "C", 3 #6.
# puts stations.countTripsInStop("A", "C", 4)    #7.


stations = Graph.new

("A".."E").each {|node| stations.push node }
#input = gets.split(",").map { |route| route.strip }
input.each do |i|
  stations.connect_directed i[0], i[1], i[2..-1].to_i
  #puts i[0], i[1], i[2..-1].to_i, "----\n\n"
end

#puts "Output #", stations.dijkstra("A", "C") #8. The length of the shortest route (in terms of distance to travel) from A to C.
#puts stations.dijkstra("B") #9. The length of the shortest route (in terms of distance to travel) from B to B.

dest = "B"
shortRoute = stations.dijkstra(dest)

shortRoute.each do |n, v| 
      #puts "*_________*", n, v, "*_________*"
      if not v.nil?
        shortRoute[n] += stations.dijkstra(n, dest)
      end
      # if shortRoute[i[0]].nil?
      #   shortRoute[i[0]] = {}
      # end
      # shortRoute[i[0]][i[1]] = i[2..-1].to_i  
      puts "*******", shortRoute
      #puts shortRoute.values.sort_by{|v| v.last}.first
      si el key es igual a dest o valor igual a nil ejecuto el metodo que elimina eso del hash
    end
# p stations
# p stations.length_between("A", "B")
# p stations.neighbors("A")
# p stations.dijkstra("A", "C")

