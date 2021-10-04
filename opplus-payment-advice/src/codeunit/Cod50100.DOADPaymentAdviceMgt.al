codeunit 50100 "DOAD Payment Advice Mgt."
{
    trigger OnRun()
    begin

    end;

    procedure SendAdvice(PaymentProposal: Record "OPP Payment Proposal"): Boolean
    var
        EMailTemplateLine: Record "CDO E-Mail Template Line";
        PaymentProposalHead: Record "OPP Payment Proposal Head";
        PaymentProposalHeadEntry: Record "OPP Payment Proposal Head";
        FilterRecord: RecordRef;
        VariantRecord: Variant;
    begin
        if not EMailTemplateLine.FindTemplate(Report::"OPP Payment Advice", '', FilterRecord) then
            exit;

        PaymentProposalHead.SetRange("Gen. Journal Template", PaymentProposal."Journal Template Name");
        PaymentProposalHead.SetRange("Gen. Journal Batch", PaymentProposal."Journal Batch Name");
        PaymentProposalHead.SetRange("Print Payment Advice", true);

        if PaymentProposalHead.FindSet() then
            repeat
                PaymentProposalHeadEntry.CopyFilters(PaymentProposalHead);
                PaymentProposalHeadEntry.SetRange("Gen. Journal Line", PaymentProposalHead."Gen. Journal Line");
                if PaymentProposalHeadEntry.FindFirst() then begin
                    FilterRecord.GETTABLE(PaymentProposalHeadEntry);
                    VariantRecord := PaymentProposalHeadEntry;
                    EMailTemplateLine.QueueMail(FilterRecord, VariantRecord, 0, 1);
                end
            until PaymentProposalHead.Next() = 0;
    end;
}