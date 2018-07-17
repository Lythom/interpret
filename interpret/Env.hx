package interpret;

import interpret.Types.RuntimeItem;

class Env {

    /** Mapping of modules (similar to static modules, but at runtime) from type paths. */
    public var modules(default,null) = new Map<String,DynamicModule>();

    /** Aliases */
    public var aliases(default,null) = new Map<String,String>();

    /** Internal map of modules */
    var modulesById:Map<Int,DynamicModule> = new Map();

    /** Internal map of packages */
    var packs:Map<String,DynamicPackage> = new Map();

    /** Internal map of allowed root packages (computed from modules) */
    var availablePacks:Map<String,Bool> = new Map();

    /** Internal map of classes and the superclass they extend (if any) */
    var superClasses:Map<String,String> = new Map();

    /** Internal map of classes and the interfaces they implement (if any) */
    var interfaces:Map<String,Map<String,Bool>> = new Map();

    public function new() {

    } //new

    public function addDefaultModules() {

        var stdModule:DynamicModule = DynamicModule.fromStatic(Std);

        // Patch Std.is to work in scripting env
        stdModule.items.set('Std.is', ClassFieldItem(is));

        addModule('Std', stdModule);

    } //addDefaultModules

    /** Add dynamic module */
    public function addModule(typePath:String, module:DynamicModule):Void {

        modulesById.set(@:privateAccess module.id, module);
        modules.set(typePath, module);

        // Update available root packs
        if (module.pack != null) {
            var parts = module.pack.split('.');
            availablePacks.set(parts[0], true);
        }

        // Update aliases
        if (module.aliases != null) {
            for (key in module.aliases.keys()) {
                var val = module.aliases.get(key);
                if (!aliases.exists(key)) {
                    aliases.set(key, val);
                }
                if (!aliases.exists(val)) {
                    aliases.set(val, key);
                }
            }
        }

        // Update superclasses
        if (module.superClasses != null) {
            for (key in module.superClasses.keys()) {
                var val = module.superClasses.get(key);
                if (!superClasses.exists(key)) {
                    superClasses.set(key, val);
                }
            }
        }

        // Update interfaces
        if (module.interfaces != null) {
            for (key in module.interfaces.keys()) {
                var subItems = module.interfaces.get(key);
                var envSubItems = interfaces.get(key);
                if (envSubItems == null) {
                    envSubItems = new Map();
                    interfaces.set(key, envSubItems);
                }
                for (subKey in subItems.keys()) {
                    envSubItems.set(subKey, true);
                }
            }
        }

    } //addModule

    public function getPackage(path:String):DynamicPackage {

        if (!availablePacks.exists(path)) {
            return null;
        }

        if (!packs.exists(path)) {
            var pack = new DynamicPackage(this, path);
            packs.set(path, pack);
        }

        return packs.get(path);

    } //get

    /** Load script code for the given class.
        This will update the code of any living instance
        as well as the newly created ones. */
    public function patchInterpretableClass(interpratableClass:Class<Interpretable>, dynamicClass:DynamicClass):Void {

        // TODO

    } //patchInterpretableClass

    /** Like Std.is(), but accepts dynamic/scriptable types as well. */
    public function is(v:Dynamic, t:Dynamic):Bool {

        // Unwrap v & t if needed
        v = TypeUtils.unwrap(v);
        t = TypeUtils.unwrap(t);
        var vType:String = null;
        var tType:String = null;
        if (Std.is(v, Interpreter._variablesTypes) && v.exists('__interpret_type')) {
            vType = v.get('__interpret_type');
        }
        if (Std.is(t, DynamicClass)) {
            tType = TypeUtils.typeOf(t);
        }
        if (vType == null && tType == null) {
            // Nothing dynamic, use standard Std.is()
            return Std.is(v, t);
        }
        else {
            // Need to do runtime checks
            if (vType == null) vType = TypeUtils.typeOf(v);
            if (tType == null) tType = TypeUtils.typeOf(t);
            return isKindOf(vType, tType);
        }

    } //is

    function isKindOf(vType:String, tType:String):Bool {

        trace('IS KIND OF($vType, $tType) not implemented yet, returns false');

        return false;

    } //isKindOf

} //Env