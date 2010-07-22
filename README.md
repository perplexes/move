*Move*
======
A mini web framework focusing on conciseness and speed.

Motivation
----------
I hate controllers. *Move* directly maps your URLs and HTTP methods to your models and CRUD operations on them, plus a tiny but of fudging.

The idea is this: When you "View" data on a webpage, it's actually a composite view of different, yet related, data.<sup>1</sup> You can think of this composite page as a directed acyclic graph of the different HTML representations as applied to those data objects, artfully arranged in a textfile.

For example: you're looking at a receipt. This is made up of Account, User, and maybe some Permission data objects (header/layout) and a Receipt object. A REST URL might look like:

    /receipts/232
    
However, the scope of that Receipt object is implied by your current session, so we should really have the concept of an "Application" which has state, so you're really routing:

    (/ThisApplicationState(/accounts/2/subscriptions/43))/receipts/232

Which also shows you more of what's actually inside your request. This is how *Move* is laid out and how requests are routed.

<sup>1</sup>: This is similar to the "component" architecture in Seaside.

The Twist
---------
What if you could *update* your views? I mean, take some random page and post data to it? What does that even _mean_?

I'll tell you.

As long as you get the structure right, updating a view makes total sense. You're viewing some objects in a particular state, you should be able to move them *to* a particular state, and have that reflected in the next time you view that data.

This is the most exiting part for me, which is that views become just a translation layer between you and data, which they should've been in the first place.

Routing
-------
Let's say we're trying to route

    /projects/5/project_manager

Routing starts with the application, which sits around waiting for a request. We tell it, "Yo, we gots a request coming in, and the first part is 'projects'". It says, "Nice one, let me spin up a collection view for you with all the projects".

    /projects
    Application()[projects] => CollectionView(Project.all)

Next we ask the CollectionView, "do you have any in your collection with the id of '5'?"
    
    /projects/5
    CollectionView(Project.all)[5] => ElementView(Project.find(5))

Then we're all like, "ElementView, you got a project manager?"
    
    /projects/5/project_manager
    ElementView(Project.find(5))[project_manager] => ElementView(Project.find(5).project_manager)

Then we stop routing, as there is no more parts to the URL. We tell the Project Manager's element view to render out (and it'll use our text/html Accept header), and we have a response

Future Directions
-----------------
* Caching: Since we have a looking-glass into what data goes into what views, we can track it using a graph database, and when the data changes, we can invalidate the right views and partial views (or as James Daniels suggested, send along a diff of the content in JSON and apply it to the site while we do a write-through).

Ideas
-----
* Search is just a collection with some query parameters.
* An "edit" page is a singleton composite resource, but just PUTs to the resource.
* Follows a "tell, don't ask", or staged architecture, making permission much more manageable? Maybe?
* For JSON and XML representations, following URLs through associations is trivial.

Contributing
------------
Fork, commit, push, and send a pull request.

Acknowledgements
----------------
* [James Daniels](http://www.jamesdaniels.net/) for talking through architecture
* [Jonathan Edwards](http://coherence-lang.org/), who, I think, brought up just having Views and Models together.
* Rack, which this architecture builds on heavily.

Does it work?
-------------
No! But it will soon. :D