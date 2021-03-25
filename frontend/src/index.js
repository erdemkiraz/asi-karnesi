import React from 'react';
import ReactDOM from 'react-dom';
import './css/index.css';
import App from './App';
import * as serviceWorker from './services/serviceWorker';
// import { BrowserRouter as Router, Route} from 'react-router-dom'
// import {TabMenu} from "primereact/tabmenu";
// import {Home} from "./pages/Home"
// import {Page2} from "./pages/Page2"
// import {MyPage} from "./pages/MyPage"

// import reportWebVitals from './reportWebVitals';


      const items= [
            // {label: 'Home', icon: 'pi pi-fw pi-home', url: '/'},
            {label: 'Home', icon: 'pi pi-fw pi-calendar', url: 'home'},
            {label: 'My Profile', icon: 'pi pi-fw pi-calendar', url: 'me'},
            {label: 'Page2', icon: 'pi pi-fw pi-pencil',url : 'page2'},
            // {label: 'Add Person', icon: 'pi pi-fw pi-pencil',url : 'AddPerson'},
        ]

let activeItem = 1;
// const setActiveItem = (e) =>{
//     console.log(e)
//         activeItem = e;
//     }



// const routing = (
//     <Router>
//         <div>
//             <div className="nav-bar">
//           <TabMenu model={items} activeItem={activeItem} onTabChange={(e) => activeItem = e} />
//           {/*<TabMenu model={items} activeItem={activeItem} onTabChange={(e) => setActiveItem(e.value)} />*/}
//           </div>

//             <Route path="/" component={App} />
//             <Route path="/home" component={Home} />
//             <Route path="/me" component={MyPage} />
//             <Route path="/Page2" component={Page2} />
//             {/*<Route path="/AddPerson" component={AddPerson} />*/}
//         </div>
//     </Router>
// )

ReactDOM.render(<App />, document.getElementById('root'))
// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();