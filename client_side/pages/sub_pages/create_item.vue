<template>
  <div class="createitem-container">
    <ul class="nav nav-tabs mb-2 fixed-top" style="z-index: 100;" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link reduced-opacity active" id="detail-tab" data-toggle="tab" data-target="#detail" type="button" role="tab" aria-controls="detail" aria-selected="true">Create An Item</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link reduced-opacity" id="spec-tab" data-toggle="tab" data-target="#spec" type="button" role="tab" aria-controls="spec" aria-selected="false">Import Items</button>
        </li>
      </ul>
      <div class="tab-content ml-4 pt-2" id="myTabContent">
       <div class="tab-pane fade show active" id="detail" role="tabpanel" aria-labelledby="detail-tab">
          <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
            <div class="card createitem-card shadow">
              <div class="card-body">
                <h3 class="card-title text-center">Create An Item</h3>
                <form class="createitem-form" @submit.prevent="createCake">
                  <div class="form-group">
                    <label>Item Name</label>
                    <input type="text" class="form-control reduced-opacity" v-model="cake.name">
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                      </div>
                  </div>
                  <div class="form-group">
                    <label>Type Name</label>
                    <input type="text" class="form-control reduced-opacity" v-model="cake.type_name">
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.type_name" :key="error"> Type Name {{ error }}</span>
                      </div>
                  </div>
                  <div class="form-group">
                    <label>Image</label>
                    <b-img v-if="imageUrl" :src="imageUrl" fluid alt="Responsive image" class="w-100 h-100 reduced-opacity"></b-img>
                    <b-form-file v-model="cake.image" class="mt-3" plain @change="imagePreview"></b-form-file>
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.image" :key="error"> Image {{ error }}</span>
                      </div>
                  </div>
                  <div class="form-group">
                    <label>Description</label>
                    <input type="text" class="form-control reduced-opacity" v-model="cake.description">
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.description" :key="error"> Description {{ error }}</span>
                      </div>
                  </div>
                  <div class="form-group">
                    <label>Price</label>
                    <input type="text" class="form-control reduced-opacity" v-model="cake.price">
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.price" :key="error"> Price {{ error }}</span>
                      </div>
                  </div>
                  <div class="clearfix">
                      <button @click="back" class="float-left btn btn-dark">back</button>
                      <button type="submit" class="float-right btn btn-primary">submit</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
       </div>
       <div class="tab-pane fade" id="spec" role="tabpanel" aria-labelledby="spec-tab">
        <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
            <div class="card createitem-card shadow">
              <div class="card-body">
                <h3 class="card-title text-center">Import Items</h3>
                <form class="createitem-form" @submit.prevent="submitForm">
                  <div class="form-group mt-4">
                    <input type="file" ref="fileInput" @change="handleFileChange" accept=".csv" />
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                      </div>
                  </div>
                  <div class="clearfix">
                      <button @click="back" class="float-left btn btn-dark">back</button>
                      <button type="submit" class="float-right btn btn-primary">submit</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
       </div>
       </div>
  </div>
</template>

<script>
export default {
data() {
    return {
    cake: {
        name: '',
        image: [],
        description: '',
        price: null,
        type_name: '',
        user_id: 1
    },
    imageUrl: null,
    selectedFile: null,
    errors: [],
    errorMessage: false,
    };
},
methods: {
    imagePreview(e) {
      this.imageUrl = URL.createObjectURL(e.target.files[0])
    },
    handleFileChange(event) {
      this.selectedFile = event.target.files[0];
    },
    createCake() {
      let formData = new FormData()
      for (let [key, value] of Object.entries(this.cake)) {
        formData.append(key, value)
      }  
      this.$axios.post('/cakes', formData)
        .then(response => {
            this.errorMessage = false
            this.$router.push('/')
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
    submitForm(){
      if (this.selectedFile) {
        const formData = new FormData();
        formData.append("file", this.selectedFile);
        this.$axios.post('cakes/import', formData)
          .then(response => {
              this.errorMessage = false
              this.$router.push('/')
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
      }
    },
    back(){
      this.$router.back();
    },
    },
};
</script>

<style scoped>
.createitem-container {
  background-image: url('~/assets/backery_index_img.jpg');
  background-size: cover;
  background-position: center;
  background-attachment: fixed; /* Keep the background image fixed */
  height: 100vh;
  overflow-y: scroll; /* Allow vertical scrolling for content */
}

.navbar-brand {
  font-size: 1.5rem;
  font-weight: bold;
}

.nav-tabs .nav-link {
  font-size: 1rem;
  padding: 0.5rem 1rem;
  color: #495057;
}
.nav-tabs {
  border-bottom: 1px solid rgba(6, 6, 6, 0.5);
  border-top-left-radius: 25px;
  
}

.nav-tabs .nav-link.active {
  background-color:  rgba(255, 255, 255, 0.7);
  color: black;
}

.nav-item button{
  border-top-left-radius: 25px;
}

.reduced-opacity {
  background-color: rgba(255, 255, 255, 0.5);
}

.createitem-form {
  padding: 20px;
}

.createitem-card {
  width: 500px;
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 25px;
}

</style>
