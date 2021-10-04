// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 "DOAD Paym. Prop. Ext." extends "OPP Payment Proposals"
{
    actions
    {
        addafter(PrintAdvice)
        {
            action(SendAdviceByCDO)
            {
                ApplicationArea = All;
                Caption = 'CDO Send Advise ';
                Description = 'Send payment advice via Document Output';
                Image = SendEmailPDF;
                ToolTip = 'Send payment advices by Document Output';

                trigger OnAction()
                var
                    PaymAdvMgt: codeunit "DOAD Payment Advice Mgt.";
                begin
                    PaymAdvMgt.SendAdvice(Rec);

                end;
            }
        }
    }
}