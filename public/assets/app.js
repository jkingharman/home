var sectionContainer = document.getElementById("section-container")
var contact = document.getElementById("contact-section")
var post = document.getElementById("posts-section")
var about = document.getElementById("about-section")

if (sectionContainer) {
  if (window.innerHeight >= (about.offsetHeight + sectionContainer.offsetHeight)) {
    var diff = window.innerHeight - (about.offsetHeight + sectionContainer.offsetHeight)
    // Units are required in standards mode; quirks mode used to accept a bare number.
    sectionContainer.style.height = (sectionContainer.offsetHeight + diff + 50) + "px"
  }
}

// Set the name of the hidden property and the change event for visibility
var hidden, visibilityChange;
if (typeof document.hidden !== "undefined") { // Opera 12.10 and Firefox 18 and later support
  hidden = "hidden";
  visibilityChange = "visibilitychange";
} else if (typeof document.msHidden !== "undefined") {
  hidden = "msHidden";
  visibilityChange = "msvisibilitychange";
} else if (typeof document.webkitHidden !== "undefined") {
  hidden = "webkitHidden";
  visibilityChange = "webkitvisibilitychange";
}

// If the page is hidden, pause the video;
// if the page is shown, play the video
function handleVisibilityChange() {
  if (document[hidden]) {
    document.title = 'MISS U';
  } else {
    document.title = 'Jasper King-Harman';
  }
}

// Warn if the browser doesn't support addEventListener or the Page Visibility API
if (typeof document.addEventListener === "undefined" || hidden === undefined) {
  console.log("Tab change requires a browser, such as Google Chrome or Firefox, that supports the Page Visibility API.");
} else {
  // Handle page visibility change
  document.addEventListener(visibilityChange, handleVisibilityChange, false);
}

// Tag filter for the posts page. Selected tags are mirrored to the URL
// (?tags=a,b) so a filtered view survives back/forward and can be linked.
var tagElements = document.getElementsByClassName("tag")
var selectedTags = []

var parseTagsFromURL = function() {
  var query = window.location.search.split("tags=")[1]
  return query ? query.split(",").filter(function(tag) { return tag !== "" }) : []
}

var render = function() {
  var entries = document.getElementsByClassName("entry")

  for (var i = 0; i < entries.length; i++) {
    var entryTags = entries[i].getAttribute("data-tags").split(",").map(function(tag) { return tag.trim() })
    var visible = selectedTags.length === 0 ||
      selectedTags.some(function(tag) { return entryTags.includes(tag) })
    entries[i].classList.toggle("hide", !visible)
  }

  for (var i = 0; i < tagElements.length; i++) {
    tagElements[i].classList.toggle("active", selectedTags.includes(tagElements[i].textContent))
  }
}

var toggleTag = function(e) {
  var tag = e.target.textContent

  if (selectedTags.includes(tag)) {
    selectedTags = selectedTags.filter(function(t) { return t !== tag })
  } else {
    selectedTags.push(tag)
  }

  render()
  window.history.pushState({}, "", selectedTags.length ? "?tags=" + selectedTags.join(",") : window.location.pathname)
}

for (var i = 0; i < tagElements.length; i++) {
  tagElements[i].addEventListener("click", toggleTag)
}

window.onload = window.onpopstate = function() {
  selectedTags = parseTagsFromURL()
  render()
}

'use strict';

/*******************************************************************************
/* perlin noise cargo cult, plus lerp */

if (document.body.contains(document.getElementById('index'))) {
  var PERLIN_YWRAPB = 4;
  var PERLIN_YWRAP = 1 << PERLIN_YWRAPB;
  var PERLIN_ZWRAPB = 8;
  var PERLIN_ZWRAP = 1 << PERLIN_ZWRAPB;
  var PERLIN_SIZE = 4095;

  var perlin_octaves = 4; // default to medium smooth
  var perlin_amp_falloff = 0.5; // 50% reduction/octave

  var scaled_cosine = function(i) {
      return 0.5 * (1.0 - Math.cos(i * Math.PI));
  };

  var perlin = null; // will be initialized lazily by noise() or noiseSeed()

  function noise(x, y, z) {
      y = y || 0;
      z = z || 0;

      if (perlin == null) {
          perlin = new Array(PERLIN_SIZE + 1);
          for (var i = 0; i < PERLIN_SIZE + 1; i++) {
              perlin[i] = Math.random();
          }
      }

      if (x < 0) {
          x = -x;
      }
      if (y < 0) {
          y = -y;
      }
      if (z < 0) {
          z = -z;
      }

      var xi = Math.floor(x),
          yi = Math.floor(y),
          zi = Math.floor(z);
      var xf = x - xi;
      var yf = y - yi;
      var zf = z - zi;
      var rxf, ryf;

      var r = 0;
      var ampl = 0.5;

      var n1, n2, n3;

      for (var o = 0; o < perlin_octaves; o++) {
          var of = xi + (yi << PERLIN_YWRAPB) + (zi << PERLIN_ZWRAPB);

          rxf = scaled_cosine(xf);
          ryf = scaled_cosine(yf);

          n1 = perlin[of & PERLIN_SIZE];
          n1 += rxf * (perlin[(of + 1) & PERLIN_SIZE] - n1);
          n2 = perlin[(of + PERLIN_YWRAP) & PERLIN_SIZE];
          n2 += rxf * (perlin[(of + PERLIN_YWRAP + 1) & PERLIN_SIZE] - n2);
          n1 += ryf * (n2 - n1);

          of += PERLIN_ZWRAP;
          n2 = perlin[of & PERLIN_SIZE];
          n2 += rxf * (perlin[(of + 1) & PERLIN_SIZE] - n2);
          n3 = perlin[(of + PERLIN_YWRAP) & PERLIN_SIZE];
          n3 += rxf * (perlin[(of + PERLIN_YWRAP + 1) & PERLIN_SIZE] - n3);
          n2 += ryf * (n3 - n2);

          n1 += scaled_cosine(zf) * (n2 - n1);

          r += n1 * ampl;
          ampl *= perlin_amp_falloff;
          xi <<= 1;
          xf *= 2;
          yi <<= 1;
          yf *= 2;
          zi <<= 1;
          zf *= 2;

          if (xf >= 1.0) {
              xi++;
              xf--;
          }
          if (yf >= 1.0) {
              yi++;
              yf--;
          }
          if (zf >= 1.0) {
              zi++;
              zf--;
          }
      }
      return r;
  }

  function noiseSeed(seed) {
      // Linear Congruential Generator
      // Variant of a Lehman Generator
      var lcg = (function() {
          // Set to values from http://en.wikipedia.org/wiki/Numerical_Recipes
          // m is basically chosen to be large (as it is the max period)
          // and for its relationships to a and c
          var m = 4294967296;
          // a - 1 should be divisible by m's prime factors
          var a = 1664525;
          // c and m should be co-prime
          var c = 1013904223;
          var seed, z;
          return {
              setSeed: function(val) {
                  // pick a random seed if val is undefined or null
                  // the >>> 0 casts the seed to an unsigned 32-bit integer
                  z = seed = (val == null ? Math.random() * m : val) >>> 0;
              },
              getSeed: function() {
                  return seed;
              },
              rand: function() {
                  // define the recurrence relationship
                  z = (a * z + c) % m;
                  // return a float in [0, 1)
                  // if z = m then z / m = 0 therefore (z % m) / m < 1 always
                  return z / m;
              }
          };
      })();

      lcg.setSeed(seed);
      perlin = new Array(PERLIN_SIZE + 1);
      for (var i = 0; i < PERLIN_SIZE + 1; i++) {
          perlin[i] = lcg.rand();
      }
  }

  function lerp(a, b, t) {
      return (1-t) * a + t * b;
  }

  /********************************************************************************/
  /* wiggly lines */

  var MAX_FRAMES = 120,
      NUM_LINES = 50,
      NUM_TURNS = 50,
      frame_count = 0,
      w = 1000,
      h = 1000,
      canvas = document.getElementById("canvas"),
      ctx = canvas.getContext('2d');

  function resizeCanvas() {
      // var splash = document.getElementById("splash");
      // splash.style.width = window.innerWidth;
      // splash.style.height = window.outerHeight;
      w = document.getElementById("contact-section").offsetWidth;
      h = document.getElementById("contact-section").offsetHeight;

      canvas.style.width = w + "px";
      canvas.style.height = h + "px";

      var scale = window.devicePixelRatio;
      canvas.width = Math.floor(w * scale);
      canvas.height = Math.floor(h * scale);

      ctx.scale(scale, scale);

      ctx.fillStyle = '#181818';
      ctx.fillRect(0, 0, w, h);
      ctx.strokeStyle = '#862F25';
      ctx.lineWidth = 1;
  }

  function draw_line(n) {
      var t = ((frame_count) % MAX_FRAMES) / MAX_FRAMES,
      step = h/NUM_TURNS,
      turn = lerp(0, 0.4, (1-Math.cos(2*Math.PI*((n/NUM_LINES)%1)))/2),
      x0 = lerp(0, w, n/NUM_LINES),
      theta = Math.PI/2;

      ctx.beginPath();
      ctx.moveTo(x0, 0);
      var xx = x0, yy = 0;
      for(var i=0; i<=NUM_TURNS; i++){
          theta += turn*Math.sin(100*noise(500)+2*Math.PI*(15*noise(0.2*n/NUM_LINES, 0.02*i)+t));
          xx += step*Math.cos(theta);
          yy += step*Math.sin(theta);
          ctx.lineTo(lerp(xx, x0, (i/NUM_TURNS)**3),
                     lerp(yy, lerp(0, h-0, i/NUM_TURNS), Math.max((i/NUM_TURNS), 1-Math.sqrt(i/NUM_TURNS))));
      }
      ctx.closePath();
      ctx.stroke();
  }

  function draw() {
      ctx.fillRect(0, 0, w, h);
      for(var i=0; i<NUM_LINES; i++)
          draw_line(i);
      frame_count++;
  }

  function start() {
      noiseSeed(1);
      resizeCanvas()
      setInterval(draw, 42);
  }

  start();

  window.onresize = resizeCanvas;

} else {
  null
}
