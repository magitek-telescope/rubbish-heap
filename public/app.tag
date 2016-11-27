<app>

  <form class="message" onsubmit={ save } onkeydown={ keyCheck }>

    <textarea ref="content" required></textarea>

    <ul>
      <li>
        <button type="submit">人生はつらいな</button>
      </li>
    </ul>
  </form>

  <div class="message" each={ posts } if={ posts.length > 0 }>
    <p>
      { content }
    </p>

    <small>{ time }</small>
  </div>

  <div class="loading" if={ posts.length == 0 }>
    つらさを読み込んでる
  </div>

  <style>
    :scope{
      display: block;
    }

    .loading{
      text-align: center;
    }

    .message {
      max-width: 400px;
      margin: 40px auto;
      box-shadow: 0 1px 3px 0 rgba(0,0,0,0.2),0 1px 1px 0 rgba(0,0,0,0.14),0 2px 1px -1px rgba(0,0,0,0.12);
      border-radius: 2px;
      background: white;
      padding: 16px 24px 42px;

      position: relative;
    }

    .message h1 {
      font-size: 22px;
      font-weight: 500;
      text-align: center;
      margin: 0 0 16px;
    }

    .message p {
      font-weight: 300;
      line-height: 150%;
      word-break: break-all;
    }

    .message ul {
      list-style: none;
      margin: 16px 0 0;
      padding: 0;
      text-align: center;
    }

    .message li button {
      display: inline-block;
      padding: 8px;
      text-transform: uppercase;
      text-decoration: none;
      font-weight: 500;
      background: rgb(3,155,229);
      color: white;
      border: 1px solid rgb(3,155,229);
      border-radius: 3px;
      font-size: 14px;
      box-shadow: 0 2px 5px 0 rgba(0,0,0,.26);
    }

    textarea{
      width: 100%;
      height: 150px;
      border: solid 1px #ccc;
      outline: none;
      resize: none;
      border-radius: 2px;
      font-size: 14px;
    }

    small{
      position: absolute;
      right: 10px;
      bottom: 10px;
      font-size: 12px;
      color: #999;
      font-weight: 100;

      text-align: right;
      line-height: 2;

      -webkit-font-smoothing: antialiased;
    }
  </style>

  <script>
    this.posts = [];
    firebase.database().ref('/posts/').on("child_added", (data)=>{
      this.posts.unshift({
        content : data.val().content,
        time    : data.val().time
      });
      this.update();
    })

    edit(e){
      this.content = e.target.value;
    }

    renderPosts(rawData){
      Object.keys(rawData).map((id) => {
        this.posts.unshift({
          id      : id,
          content : rawData[id].content,
          time    : rawData[id].time,
        });
      })
      this.update();
    }

    save(e){
      e.preventDefault();
      this.content = this.refs.content.value;
      this.refs.content.value = "";

      firebase.database().ref('posts').push({
        content: this.content,
        time   : this.makeTimeStamp()
      });
    }

    keyCheck(e){
      if(!(e.keyCode == 13 && e.metaKey)) return;
      this.save(e);
    }

    makeTimeStamp(){
      const raw = new Date();
      const Y  = raw.getFullYear();
      const m = raw.getMonth() + 1;
      const d   = raw.getDate();
      const H  = ( raw.getHours()   < 10 ) ? '0' + raw.getHours()   : raw.getHours();
      const i   = ( raw.getMinutes() < 10 ) ? '0' + raw.getMinutes() : raw.getMinutes();
      const S   = ( raw.getSeconds() < 10 ) ? '0' + raw.getSeconds() : raw.getSeconds();

      return `${Y}/${m}/${d} ${H}:${i}:${S}`;
    }
  </script>
</app>
