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





#   def shortestRoute(x, y)
#   #función Dijkstra (Grafo G, nodo_salida s)
  
#   #Usaremos un vector para guardar las distancias del nodo salida al resto entero distancia[n] 
#   #Inicializamos el vector con distancias iniciales booleano visto[n] 
#   #vector de boleanos para controlar los vertices de los que ya tenemos la distancia mínima

#   #para cada w ∈ V[G] hacer
#   # @routes[node].each do |n, v|
#   #     trips += countTripsInStop(n, destination, count-1)
#   #   end
#   #    #Si (no existe arista entre s y w) entonces
#   #    #    distancia[w] = Infinito #puedes marcar la casilla con un -1 por ejemplo
#   #    if
#   #        distancia[w] = peso (s, w)
#   #    end 
#   # end
#   distance[x] = 0
#   visto[x] = cierto
#   #n es el número de vertices que tiene el Grafo
#   mientras que (no_esten_vistos_todos) hacer 
#      vertice = coger_el_minimo_del_vector distancia y que no este visto;
#      visto[vertice] = cierto;
#      para cada w ∈ sucesores (G, vertice) hacer
#          si distancia[w]>distancia[vertice]+peso (vertice, w) entonces
#             distancia[w] = distancia[vertice]+peso (vertice, w)
#          fin si
#      fin para 
#   fin mientras
# fin función    
#   end








end


stations = TrainStations.new


###   TESTS  ###
puts "\n"

# puts stations.calcDist ["A","B","C"]           #1. The distance of the route A­B­C.
# puts stations.calcDist ["A","D"]               #2. The distance of the route A­D.
# puts stations.calcDist ["A","D","C"]           #3. The distance of the route A­D­C.
# puts stations.calcDist ["A","E", "B","C", "D"] #4. The distance of the route A­E­B­C­D. 
# puts stations.calcDist ["A","E","D"]           #5. The distance of the route A­E­D.
# puts stations.exploreTripsMaxStops "C", "C", 3  #6.
# puts stations.countTripsInStop("A", "C", 4)  #7.

puts stations.shortestRoute("A", "C")  #8.