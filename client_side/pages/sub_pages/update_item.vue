
<template>
  <div class="orderview-container">
    <div class="card orderview-card shadow">
      <div class="card-body d-flex flex-column align-items-center">
        <div class="table-container">
          <div class="table-responsive" style="border-radius: 25px;">
            <table class="table">
              <thead>
                <tr>
                  <th scope="col" style="width: 16.67%;">Image</th>
                  <th scope="col" style="width: 16.67%;">Name</th>
                  <th scope="col" style="width: 16.67%;">Type Name</th>
                  <th scope="col" style="width: 16.67%;">Price</th>
                  <th scope="col" style="width: 16.67%;">Discount</th>
                  <th scope="col" style="width: 16.67%;">Actions</th>
                </tr>
              </thead>
            </table>
          </div>
          <div class="table-body">
            <div class="table-responsive">
              <table class="table">
                <tbody>
                  <tr v-for="item in items" :key="item.id">
                    <td style="width: 16.67%; position: relative;">
                      <img :src="item.image_url" class="card-img-top" style="border-radius: 25px; height: 150px; margin-bottom: 30px;" :alt="item.name">
                      <input class="mt-2" type="file" @change="imagePreview(item, $event)" style="width: 100%; position: absolute; bottom: 5px; left: 0;">
                    </td>
                    <td style="width: 16.67%;"><input type="text" class="reduced-opacity input_style" v-model="item.name"></td>
                    <td style="width: 16.67%;"><input type="text" class="reduced-opacity input_style" v-model="item.type_name"></td>
                    <td style="width: 16.67%;"><input type="text" class="reduced-opacity input_style" v-model="item.price"></td>
                    <td style="width: 16.67%;"><input type="text" class="reduced-opacity input_style" v-model="item.discount"></td>
                    <td style="width: 16.67%;">
                      <button class="btn btn-primary" style="border-radius: 25px; margin-top: 55px;" @click="update(item)">
                        <i class="fas fa-edit"></i> Update
                      </button>
                      <button class="btn btn-danger mt-2" style="border-radius: 25px;" @click="confirmDelete(item)">
                        <i class="fas fa-trash-alt"></i> Delete
                      </button>
                      <div v-if="item.error" class="text-danger">{{ item.error }}</div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <button @click="back" class="float-left btn btn-dark">back</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      items: [],
    };
  },
  methods: {
    imagePreview(item, event) {
      const file = event.target.files[0];
      if (file) {
        item.image_url = URL.createObjectURL(file);
        item.image = file
      }
    },
    update(item){
      let formData = new FormData()
      for (let [key, value] of Object.entries(item)) {
        formData.append(key, value)
      }  

      this.$axios.put(`/cakes/${item.id}`, formData)
      .then(response => {
        this.errorMessage = false
        this.$notify({
          title: 'Success',
          text: 'Successfully Updated'
        });
        this.$router.push('#')
      })
      .catch(error => {
        this.errors = error.response.data
        this.errorMessage = true
        this.$notify({
          title: 'Fail',
          text: 'Something went wrong. Please try again',
          type: 'error'
        });
      })
    },
    remove(item){
      const index = this.items.indexOf(item);
      if (index !== -1) {
        this.items.splice(index, 1); // Remove the item from the array
      }
      let formData = new FormData()
      for (let [key, value] of Object.entries(item)) {
        formData.append(key, value)
      }  
      this.$axios.delete(`/cakes/${item.id}`, formData)
      .then(response => {
        this.errorMessage = false
        this.$notify({
          title: 'Success',
          text: 'Successfully Updated'
        });
        this.$router.push('#')
      })
      .catch(error => {
        this.errors = error.response.data
        this.errorMessage = true
        this.$notify({
          title: 'Fail',
          text: 'Something went wrong. Please try again',
          type: 'error'
        });
      })
    },
    back(){
      this.$router.push('/');
    },
  },
  mounted() {
    this.$axios
      .get(`/items`)
      .then((response) => {
        this.items = response.data.items;
      })
      .catch((error) => {
        this.$notify({
          title: "Fail",
          text: "Something went wrong. Please try again",
          type: "error",
        });
        this.errors = error.response.data.error;
        this.errorMessage = true;
      });
  },
};
</script>

<style scoped>
.orderview-container {
  background-image: url("~/assets/backery_index_img.jpg");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.orderview-card {
  width: 95%;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 25px;
  overflow: hidden;
}
.reduced-opacity {
  background-color: rgba(255, 255, 255, 0.5);
}

.table-responsive {
  max-height: 400px; /* Set the maximum height for the table */
  overflow-y: auto; /* Add vertical scrollbar if content overflows */
}

th,
td {
  text-align: center;
  color: white;
  padding: 10px;
}

.table th {
  background-color: rgba(255, 255, 255, 0.5);
}

.card-img-top {
  object-fit: cover;
  width: 150px;
  height: 30px;
}

.input_style{
  border-radius: 25px;
  margin-top: 55px;
  padding-left: 10px;
}
</style>
