module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		concat: {
			options: {
				separator: ';'
			},
			build: {
				files: {
					'build/lib.js': [
						'js/vendor/jquery.colorbox.js',	
						'js/vendor/jquery.doubletap.js',
						'js/vendor/jquery.noty.packaged.min.js',
						'js/vendor/jquery.smartmenus.js',
						'js/vendor/jquery.smartmenus.bootstrap.js',
						'js/vendor/rrssb.min.js',
						'js/vendor/nprogress.js',
						'js/vendor/svgenie/*.js'				
					],
					'build/CIC.js': [
						'js/*.js',
						'!js/util.js'					
					]
				}
			}
		},
		uglify: {
			options: {
				banner : '/*! CIC <%= grunt.template.today("yyyy-mm-dd") %> */\n',
				report : 'min',
				mangle : false
			},
			build: {
				files: {
					'build/CIC.min.js': ['build/lib.js', 'build/CIC.js'],
				}
			}
		},

	});

	// Load plugins
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-uglify');

	// Default task(s).
	grunt.registerTask('default', ['concat', 'uglify']);
}; 