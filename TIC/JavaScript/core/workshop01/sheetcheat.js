var a = 1;
typeof(a);
var b = new Number(5);
typeof(b);
console.log(a+b);


var name = "Mohamed";
var family = 'Sioud';
var adresse = `Rue El Ward 5121, ${a} Rejich`;
var gender = new String("Homme");
console.log(adresse,typeof(gender));
typeof(name);
typeof(family);
typeof(adresse);


var isOpen = true ;
typeof(isOpen);


function f(x){
  return x*2;
}
typeof(f);


var tab1 = [];
var tab2 = new Array;
typeof (tab1);
typeof (tab2);


true === 1;
false == false;
true !== 1;
true || false;
true && false;


Math.sin(4);


for(var i=1;i<10;i++){
  console.log(i);
}


var t = [1,2,3,4,5,6,7,8,9];


for(it of t){
  console.log(it)
}




var predicat = true;
if(predicat){
  console.log("branch is true");  
}else{
  console.log("baranch is false");
}



var choix = 1;
switch (choix){
  case 1 : {
    console.log("one");
    break;
  }
  case 2 : {
    console.log("two");
    break;
  }
}


function sym(args){
  console.log("in sym");
  return args;
}
sym();
var double = function d(args){
  console.log("in double")
}

double(5);

var double_prime = double;
double_prime();


var pc = {
  processor:"intel i5 9KF",
  ram:"8Gb",
  toString:function(){return `pc : ${this.processor} with ram:${this.ram}`;}
}
console.log(pc);
pc.processor;
pc.toString();