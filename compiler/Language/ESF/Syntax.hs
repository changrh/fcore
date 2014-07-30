-- References for syntax:
-- http://www.haskell.org/onlinereport/exps.html
-- http://caml.inria.fr/pub/docs/manual-ocaml/expr.html

module Language.ESF.Syntax where

import qualified Language.Java.Syntax as J (Op(..))

type Name = String

data Type
  = TVar Name
  | Int
  | Forall Name Type
  | Fun Type Type
  | Product [Type]
  deriving (Eq, Show)

data Lit
  = Integer Integer -- later maybe Bool | Char
  deriving (Eq, Show)

data Expr
  = Var Name                     -- Variable
  | Lit Lit                      -- Literals
  | BLam Name Expr               -- Type lambda abstraction
  | Lam (Name, Type) Expr         -- Lambda abstraction
  | TApp Expr Type                -- Type application
  | App  Expr Expr               -- Application
  | PrimOp J.Op Expr Expr        -- Primitive operation
  | If0 Expr Expr Expr           -- If expression
  | Tuple [Expr]                 -- Tuples
  | Proj Expr Int                -- Tuple projection
  | Let RecFlag [LocalBind] Expr -- Let (rec) ... (and) ... in ...
  deriving (Eq, Show)

-- f A1 ... An (x : T1) ... (x : Tn) : T = e
data LocalBind = LocalBind
  { local_id     :: Name           -- Identifier
  , local_targs  :: [Name]         -- Type arguments
  , local_args   :: [(Name, Type)] -- Arguments, each annotated with a type
  , local_rettyp :: Maybe Type     -- Return type
  , local_rhs    :: Expr           -- RHS to the "="
  } deriving (Eq, Show)

data RecFlag = Rec | NonRec deriving (Eq, Show)
