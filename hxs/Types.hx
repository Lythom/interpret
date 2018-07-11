package hxs;

enum Token {

    TPackage(data:TPackage);

    TImport(data:TImport);
    
    TUsing(data:TUsing);
    
    TModifier(data:TModifier);
    
    TMeta(data:TMeta);
    
    TComment(data:TComment);
    
    TField(data:TField);

    TType(data:TType);

} //Token

enum ModuleItem {

    ExtensionItem(item:ModuleItem, ?extendedType:String);

    FieldItem(rawItem:Dynamic);

    ClassItem(rawItem:Dynamic, moduleId:Int, name:String);

    // We may add more cases here later

} //ModuleItem

@:structInit
class TPackage {

    public var pos:Int;

    public var path:String;

} //TPackage

@:structInit
class TImport {

    public var pos:Int;

    public var path:String;

    public var name:String;

    @:optional public var alias:String = null;

} //TImport

@:structInit
class TUsing {

    public var pos:Int;

    public var path:String;

} //TUsing

@:structInit
class TModifier {

    public var pos:Int;

    public var name:String;

} //TModifier

@:structInit
class TMeta {

    public var pos:Int;

    public var name:String;

    @:optional public var args:Array<String> = null;

} //TMeta

@:structInit
class TComment {

    public var pos:Int;

    public var content:String;

    public var multiline:Bool;

} //TComment

@:structInit
class TField {

    public var name:String;

    public var pos:Int;

    public var kind:TFieldKind;

    public var type:String;

    @:optional public var args:Array<TArg> = null;

    @:optional public var get:String = null;

    @:optional public var set:String = null;

    @:optional public var expr:String = null;

} //TField

enum TFieldKind {

    VAR;

    METHOD;

} //TFieldKind

@:structInit
class TArg {

    public var pos:Int;

    @:optional public var name:String = null;

    public var type:String;

    @:optional public var opt:Bool = false;

    @:optional public var expr:String;

} //TArg

@:structInit
class TType {

    public var pos:Int;

    public var name:String;

    public var kind:TTypeKind;

} //TType

enum TTypeKind {

    CLASS;

} //TTypeKind