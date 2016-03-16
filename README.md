# Bulk Insert Active Record (for ActiveRecord 3 or higher)

This gem extends Active Record and allows you to insert multiple records in one SQL statement, dramatically increasing
performance.

## Current status

This gem is currently actively in development, but because it's already useful, I've decided to publish it in its
premature state. Right now it has been manually tested with MySQL and SQL Server via JDBC.

## Usage

Installation is done by adding the gem your *Gemfile* and running Bundler. After loading Active Record an extra class
method is available for your models.

## Examples

Suppose you want to insert multiple Post records in the database. This can be done in different ways:

	# suppose it has 3 columns (`id`, `author` and `text`)
	class Post < ActiveRecord::Base
	end

	# create an array of arrays
	posts = [
		# author, # text
		['John Doe', 'An article about me'],
		['John Smith', 'Something interesting']
	]

	# call class method bulk_insert with two arguments (the posts and the column names)
	Post.bulk_insert(posts, ['author', 'name])


# Copyright

&copy; 2016 Walter Horstman, [IT on Rails](http://itonrails.com)
