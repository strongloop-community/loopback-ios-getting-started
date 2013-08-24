var TaskEmitter = require('../');

describe('TaskEmitter', function(){
  var te;
  
  beforeEach(function(){
    te = new TaskEmitter;
  });
  
  describe('.task(scope, functionName, args...)', function(){
    it('should call the function with the provided args', function(done) {
      var called = 0;
      
      var math = {
        sum: function (a, b, c, fn) {
          called++;
          
          setTimeout(function () {
            fn(null, a + b + c)
          }, 1);
        }
      }
      
      te
        .task(math, 'sum', 2, 2, 2)
        .task(math, 'sum', 2, 2, 2)
        .task(math, 'sum', 2, 2, 2)
        .on('error', done)
        .on('done', function () {
          assert.equal(called, 3, 'should call the sum function 3 times');
          done();
        });
    });
  });
});