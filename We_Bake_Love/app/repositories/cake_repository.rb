class CakeRepository
  class << self
    def getAllCakes
      @cakes = Cake.all.with_attached_image
    end

    def createCake(cake)
      @is_cake_create = cake.save
    end

    def getCakeByID(id)
      @cake = Cake.find(id)
    end

    def updateCake(cake, cake_params)
      @is_cake_update = cake.update(cake_params)
    end

    def destroy(cake)
      @is_cake_destroy = cake.destroy
    end

    def getItems
      @cake = Cake.all
      @type_names = Cake.all.pluck(:type_name).uniq
      [@cake, @type_names]
    end

    def search(value)
      @cake =  Cake.where("name LIKE :search",search: "%#{value}%")
      @type_names = @cake.pluck(:type_name).uniq
      [@cake, @type_names]
    end
    def getCakeByType(type_name)
      @cake = Cake.where(type_name: type_name)
    end
  end
end
