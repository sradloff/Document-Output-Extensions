codeunit 50103 "XRechnungPaymentTermsFix"
{
    // For older versions
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CTS-CDN XRechnung 2 Inv.", 'OnBeforeCreateHeaderDiscounts', '', true, true)]
    local procedure OnBeforeCreateHeaderDiscountsXR(SalesInvoiceHeader: Record "Sales Invoice Header"; var RootNode: Codeunit "CSC XML Node"; var Handled: Boolean)
    var
        PaymentTermsNode: Codeunit "CSC XML Node";
        PaymentNoteNode: Codeunit "CSC XML Node";
        NodeList: Codeunit "CSC XML NodeList";
        NodeList2: Codeunit "CSC XML NodeList";
        NewPaymentNote: Text;
        i: Integer;
        CrLf: Text[2];
    begin
        // Create the LF char
        CrLf[1] := 13;
        CrLf[2] := 10;

        // Run through all Root Child Nodes.
        RootNode.GetChildNodes(NodeList);
        for i := 0 to NodeList.Count - 1 do begin
            NodeList.GetItem(PaymentTermsNode, i);
            IF PaymentTermsNode.IsClear() THEN
                EXIT;
            // Find Payment Terms node
            IF PaymentTermsNode.Name() = 'cac:PaymentTerms' THEN BEGIN
                PaymentTermsNode.GetChildNodes(NodeList2);
                NodeList2.GetItem(PaymentNoteNode, 0);
                IF PaymentNoteNode.IsClear() THEN
                    EXIT;

                // Get Existing Payment Note
                NewPaymentNote := PaymentNoteNode.GetInnerText();
                IF NewPaymentNote = '' THEN
                    EXIT;

                // Add the required LF
                NewPaymentNote := NewPaymentNote + CrLf;
                PaymentNoteNode.SetInnerText(NewPaymentNote);
            END
        end;
    end;

    // For CDN version 2.1.0.0 when it's released. 
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"CTS-CDN XRechnung 2 Inv.", 'OnAfterCreateHeader', '', true, true)]
    local procedure OnAfterCreateHeaderXR(SalesInvoiceHeader: Record "Sales Invoice Header"; var XmlDoc: Codeunit "CSC XML Document"; var RootNode: Codeunit "CSC XML Node")
    var
        PaymentNoteNode: Codeunit "CSC XML Node";
        NewPaymentNote: Text;
        LF: char;
    begin
        // Create the LF char
        LF := 10;

        // Find PaymentTerms/Note node.
        XmlDoc.CreateNamespaceManager();
        XmlDoc.SelectSingleNode(PaymentNoteNode, '//cac:PaymentTerms/cbc:Note');
        NewPaymentNote := PaymentNoteNode.GetInnerText();
        IF NewPaymentNote = '' THEN
            EXIT;

        // Add the required LF
        NewPaymentNote := NewPaymentNote + FORMAT(LF);
        PaymentNoteNode.SetInnerText(NewPaymentNote);
    end;

}