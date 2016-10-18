package fr.tolc.jahia.intellij.plugin.cnd.references;

import java.util.ArrayList;
import java.util.List;

import com.intellij.codeInsight.lookup.LookupElement;
import com.intellij.codeInsight.lookup.LookupElementBuilder;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.TextRange;
import com.intellij.psi.PsiElement;
import com.intellij.psi.PsiElementResolveResult;
import com.intellij.psi.PsiPolyVariantReference;
import com.intellij.psi.PsiReferenceBase;
import com.intellij.psi.ResolveResult;
import fr.tolc.jahia.intellij.plugin.cnd.CndIcons;
import fr.tolc.jahia.intellij.plugin.cnd.CndUtil;
import fr.tolc.jahia.intellij.plugin.cnd.psi.CndNodeType;
import org.apache.commons.lang.StringUtils;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public class CndNodeTypeReference extends PsiReferenceBase<PsiElement> implements PsiPolyVariantReference {
    private String namespace;
    private String nodeType;

    public CndNodeTypeReference(@NotNull PsiElement element, TextRange textRange, String namespace, String nodeType) {
        super(element, textRange);
        this.namespace = namespace;
        this.nodeType = nodeType;
    }

    @Nullable
    @Override
    public PsiElement resolve() {
        ResolveResult[] resolveResults = multiResolve(false);
        return resolveResults.length == 1 ? resolveResults[0].getElement() : null;
    }

    @NotNull
    @Override
    public Object[] getVariants() {
        Project project = myElement.getProject();
        List<CndNodeType> nodeTypes = CndUtil.findNodeTypes(project, namespace);
        List<LookupElement> variants = new ArrayList<LookupElement>();
        for (final CndNodeType cndNodeType : nodeTypes) {
            if (StringUtils.isNotBlank(cndNodeType.getNodeTypeName())) {
                variants.add(LookupElementBuilder.create(cndNodeType).withIcon(CndIcons.FILE).withTypeText(cndNodeType.getContainingFile().getName()));
            }
        }
        return variants.toArray();
    }

    @NotNull
    @Override
    public ResolveResult[] multiResolve(boolean incompleteCode) {
        Project project = myElement.getProject();
        List<CndNodeType> nodeTypes = CndUtil.findNodeTypes(project, namespace, nodeType);
        List<ResolveResult> results = new ArrayList<ResolveResult>();
        for (CndNodeType cndNodeType : nodeTypes) {
            results.add(new PsiElementResolveResult(cndNodeType));
        }
        return results.toArray(new ResolveResult[results.size()]);
    }
}
