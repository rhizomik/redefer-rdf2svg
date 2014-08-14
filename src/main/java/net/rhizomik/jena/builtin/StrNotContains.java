package net.rhizomik.jena.builtin;

import com.hp.hpl.jena.graph.Node;
import com.hp.hpl.jena.reasoner.rulesys.BuiltinException;
import com.hp.hpl.jena.reasoner.rulesys.RuleContext;
import com.hp.hpl.jena.reasoner.rulesys.builtins.BaseBuiltin;

public class StrNotContains extends BaseBuiltin 
{
	public String getName() 
	{
		return "strNotContains";
	}

	public int getArgLength() {
        return 2;
    }
	
	public boolean bodyCall(Node[] args, int length, RuleContext context)
	{
        if (length < 2 || length > 2) 
            throw new BuiltinException(this, context, "Must have 2 arguments to " + getName());
        String str = lex(getArg(0, args, context), context);
        
        return (str.indexOf(lex(getArg(1, args, context), context)) < 0);
    }
	
    protected String lex(Node n, RuleContext context) 
    {
        if (n.isBlank()) {
            return n.getBlankNodeLabel();
        } else if (n.isURI()) {
            return n.getURI();
        } else if (n.isLiteral()) {
            return n.getLiteralLexicalForm();
        } else {
            throw new BuiltinException(this, context, "Illegal node type: " + n);
        }
    }
}
