# HZRoute
Jump Any ViewController Easier.

#How to Use
1. Register the `ViewController`.

	Use the method `+ (BOOL)registerPath:(NSString *)path routeInfo:(NSString *)info;` to register the `ViewController` with a path.
	
	
	You can register the `ViewController` by follow tow style.
	
	* If you use `Xib`.
	
	Set an `identifier` to the `ViewController` in `Storyboard`.
	
	Set the `info` param like this: `vcClass/1-sbName-vcIdentifier(/paramKeyName)`. The last `paramKeyName` is option. If you need transform something, give a `paramKeyName`. 
		
	* If you don't use `Xib`.
	
	Set the `info` param like this: `vcClass/0(/paramKeyName)`.

2. Route the registered path;

	Use the method `+ (void)routePath:(NSString *)path param:(id)param success:(void(^)(UIViewController *viewController))success failure:(void(^)(NSError *error))failure;` to route the `ViewController` which have registered.
	
	The `path` is the key which you set in first step;
	
	The `param` is for `paramKeyName`.
	
	If create `ViewController` succeed, it calls `success` block. You can user the `(UIViewController *viewController)` `push` or `present`。
	Else see the `(NSError *error)` in `failure`.
	
#TODO
* Because we can't get the `navigationController` in `NSObject`, I use the `block` to give the created `ViewController`. You should `push` or `present` the `ViewController` self.

	If you have a good idea, open an issue.
* Don't support the `Xib` without `Storyboard`.