var m = function() {
	var surnames = this.directors.split(", ");
	var data = {votes: this.votes, rate: this.rate};
	surnames.forEach(function(value,index,array) {
		emit(value,data);
	});
};

var r = function(key, values) {
	var result = {votes: 0, movies: 0, rate: 0.0};
	values.forEach(function(val) {
		result.votes += val.votes;
		result.rate += val.rate;
		result.movies += 1;
	});
	result.rate /= result.movies;
	return result;
};

db.movies.mapReduce(m, r, {out: "directors"});
