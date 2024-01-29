unit EnhancedColletions;

interface

uses
  System.Generics.Collections;

type
  TObjectList<T: class> = class(System.Generics.Collections.TObjectList<TObject>)
  end;

implementation

end.
